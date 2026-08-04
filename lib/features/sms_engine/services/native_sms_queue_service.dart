import 'dart:io';

import 'package:flutter/services.dart';

class QueuedSms {
  const QueuedSms({
    required this.sender,
    required this.body,
    required this.timestamp,
  });

  final String sender;
  final String body;
  final DateTime timestamp;
}

class NativeSmsQueueService {
  static const MethodChannel _channel = MethodChannel(
    'com.smartspend.app/sms_queue',
  );

  Future<List<QueuedSms>> drain() async {
    if (!Platform.isAndroid) {
      return const <QueuedSms>[];
    }

    final List<dynamic>? payload = await _channel.invokeListMethod<dynamic>(
      'drainPendingSms',
    );
    if (payload == null) {
      return const <QueuedSms>[];
    }

    return payload
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> item) {
          final int milliseconds =
              (item['timestamp'] as num?)?.toInt() ??
              DateTime.now().millisecondsSinceEpoch;
          return QueuedSms(
            sender: item['sender'] as String? ?? '',
            body: item['body'] as String? ?? '',
            timestamp: DateTime.fromMillisecondsSinceEpoch(milliseconds),
          );
        })
        .toList(growable: false);
  }
}
