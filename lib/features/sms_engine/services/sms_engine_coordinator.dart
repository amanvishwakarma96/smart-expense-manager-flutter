import 'dart:async';

import 'package:smart_expense_manager/features/sms_engine/services/native_sms_queue_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_inbox_import_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_parser_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/category_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/merchant_rule_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/transaction_repository.dart';
import 'package:smart_expense_manager/features/transactions/services/transaction_category_classifier.dart';

class SmsScanSummary {
  const SmsScanSummary({
    required this.scanned,
    required this.matched,
    required this.added,
    this.permission = SmsPermissionResult.granted,
  });

  final int scanned;
  final int matched;
  final int added;
  final SmsPermissionResult permission;
}

class SmsEngineCoordinator {
  SmsEngineCoordinator({
    required TransactionRepository transactionRepository,
    required MerchantRuleRepository merchantRuleRepository,
    required CategoryRepository categoryRepository,
    SmsParserService? parser,
    SmsInboxImportService? inbox,
    NativeSmsQueueService? nativeQueue,
    TransactionCategoryClassifier? categoryClassifier,
  }) : _transactions = transactionRepository,
       _rules = merchantRuleRepository,
       _categories = categoryRepository,
       _parser = parser ?? SmsParserService(),
       _inbox = inbox ?? SmsInboxImportService(),
       _nativeQueue = nativeQueue ?? NativeSmsQueueService(),
       _categoryClassifier =
           categoryClassifier ?? const TransactionCategoryClassifier();

  final TransactionRepository _transactions;
  final MerchantRuleRepository _rules;
  final CategoryRepository _categories;
  final SmsParserService _parser;
  final SmsInboxImportService _inbox;
  final NativeSmsQueueService _nativeQueue;
  final TransactionCategoryClassifier _categoryClassifier;

  StreamSubscription<void>? _queueSubscription;
  bool _draining = false;
  bool _drainRequested = false;

  Future<void> startAutomaticProcessing() async {
    await _safeDrain();
    await _refreshRecentInboxIfGranted();
    _queueSubscription ??= _nativeQueue.queuedEvents.listen((_) {
      unawaited(_safeDrain());
    });
  }

  Future<void> dispose() async {
    await _queueSubscription?.cancel();
    _queueSubscription = null;
  }

  Future<SmsScanSummary> drainNativeQueue() async {
    final List<QueuedSms> queued = await _nativeQueue.drain();
    return _ingest(queued);
  }

  Future<SmsScanSummary> requestPermissionAndScanInbox() async {
    final SmsImportResult result = await _inbox.importRecent();
    if (result.permission != SmsPermissionResult.granted) {
      return SmsScanSummary(
        scanned: 0,
        matched: 0,
        added: 0,
        permission: result.permission,
      );
    }
    final SmsScanSummary summary = await _ingest(result.messages);
    return SmsScanSummary(
      scanned: summary.scanned,
      matched: summary.matched,
      added: summary.added,
      permission: result.permission,
    );
  }

  Future<void> _refreshRecentInboxIfGranted() async {
    try {
      final SmsImportResult result = await _inbox.importRecentIfGranted();
      if (result.permission == SmsPermissionResult.granted) {
        await _ingest(result.messages);
      }
    } catch (_) {
      // Startup refresh is best-effort; manual scan stays available in Settings.
    }
  }

  Future<void> _safeDrain() async {
    try {
      await _drainSerially();
    } catch (_) {
      // The encrypted native queue remains available for the next drain attempt.
    }
  }

  Future<void> _drainSerially() async {
    if (_draining) {
      _drainRequested = true;
      return;
    }
    _draining = true;
    try {
      do {
        _drainRequested = false;
        await drainNativeQueue();
      } while (_drainRequested);
    } finally {
      _draining = false;
    }
  }

  Future<SmsScanSummary> _ingest(List<QueuedSms> messages) async {
    int matched = 0;
    int added = 0;
    final List<CategoryModel> categories = await _categories.getAll();

    for (final QueuedSms sms in messages) {
      final parsed = _parser.parse(
        body: sms.body,
        sender: sms.sender,
        receivedAt: sms.timestamp,
      );
      if (parsed == null) {
        continue;
      }
      matched++;

      final String fingerprint = await _transactions.fingerprintFor(
        '${sms.sender}|${sms.timestamp.millisecondsSinceEpoch}|${sms.body}',
      );
      final int? learnedCategoryId = await _rules.matchCategory(
        parsed.merchantName,
      );
      final int? categoryId =
          learnedCategoryId ??
          _categoryClassifier.inferCategoryId(
            categories: categories,
            transaction: parsed,
          );
      final int id = await _transactions.addSmsTransaction(
        amount: parsed.amount,
        type: parsed.type,
        purpose: parsed.purpose,
        merchant: parsed.merchantName,
        timestamp: parsed.timestamp,
        accountTail: parsed.accountTail,
        originalSmsText: parsed.originalText,
        fingerprint: fingerprint,
        categoryId: categoryId,
      );
      if (id >= 0) {
        added++;
      }
    }

    return SmsScanSummary(
      scanned: messages.length,
      matched: matched,
      added: added,
    );
  }
}
