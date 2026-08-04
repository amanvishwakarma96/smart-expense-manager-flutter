import 'package:smart_expense_manager/features/sms_engine/services/native_sms_queue_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_inbox_import_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_parser_service.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/merchant_rule_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/transaction_repository.dart';

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
    SmsParserService? parser,
    SmsInboxImportService? inbox,
    NativeSmsQueueService? nativeQueue,
  })  : _transactions = transactionRepository,
        _rules = merchantRuleRepository,
        _parser = parser ?? SmsParserService(),
        _inbox = inbox ?? SmsInboxImportService(),
        _nativeQueue = nativeQueue ?? NativeSmsQueueService();

  final TransactionRepository _transactions;
  final MerchantRuleRepository _rules;
  final SmsParserService _parser;
  final SmsInboxImportService _inbox;
  final NativeSmsQueueService _nativeQueue;

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

  Future<SmsScanSummary> _ingest(List<QueuedSms> messages) async {
    int matched = 0;
    int added = 0;

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
      final int? categoryId = await _rules.matchCategory(parsed.merchantName);
      final int id = await _transactions.addSmsTransaction(
        amount: parsed.amount,
        type: parsed.type,
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
