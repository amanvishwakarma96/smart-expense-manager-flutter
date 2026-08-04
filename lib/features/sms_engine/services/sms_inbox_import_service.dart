import 'dart:io';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_expense_manager/features/sms_engine/services/native_sms_queue_service.dart';

enum SmsPermissionResult { granted, denied, permanentlyDenied, unsupported }

class SmsImportResult {
  const SmsImportResult({
    required this.permission,
    required this.messages,
  });

  final SmsPermissionResult permission;
  final List<QueuedSms> messages;
}

class SmsInboxImportService {
  SmsInboxImportService({SmsQuery? query}) : _query = query ?? SmsQuery();

  final SmsQuery _query;

  Future<SmsImportResult> importRecent({int count = 150}) async {
    if (!Platform.isAndroid) {
      return const SmsImportResult(
        permission: SmsPermissionResult.unsupported,
        messages: <QueuedSms>[],
      );
    }

    final PermissionStatus status = await Permission.sms.request();
    if (status.isPermanentlyDenied) {
      return const SmsImportResult(
        permission: SmsPermissionResult.permanentlyDenied,
        messages: <QueuedSms>[],
      );
    }
    if (!status.isGranted) {
      return const SmsImportResult(
        permission: SmsPermissionResult.denied,
        messages: <QueuedSms>[],
      );
    }

    final List<SmsMessage> messages = await _query.querySms(
      kinds: <SmsQueryKind>[SmsQueryKind.inbox],
      count: count.clamp(1, 500).toInt(),
    );

    return SmsImportResult(
      permission: SmsPermissionResult.granted,
      messages: messages.map((SmsMessage message) {
        return QueuedSms(
          sender: message.address ?? '',
          body: message.body ?? '',
          timestamp: message.date ?? DateTime.now(),
        );
      }).toList(growable: false),
    );
  }
}
