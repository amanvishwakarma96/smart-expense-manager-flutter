import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Returns true when PiggyAI may continue into the Android SMS permission flow.
///
/// If SMS access is already granted, no disclosure is repeated. Otherwise the
/// policy disclosure is shown immediately before the caller triggers the
/// Android runtime permission request.
Future<bool> confirmSmsAccessIfNeeded(BuildContext context) async {
  final PermissionStatus status = await Permission.sms.status;
  if (status.isGranted) {
    return true;
  }
  if (!context.mounted) {
    return false;
  }

  final bool? accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Use bank SMS for expense detection?'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'PiggyAI reads SMS messages on this Android device to find bank '
                'and payment transaction alerts, including new alerts received '
                'while the app is not open.',
              ),
              SizedBox(height: 12),
              Text(
                'Messages are processed only on this device. Matching financial '
                'alerts become pending transactions for your review; unmatched '
                'messages are not stored.',
              ),
              SizedBox(height: 12),
              Text(
                'PiggyAI does not send your SMS text or detected financial data '
                'to a server, advertiser, analytics provider, or other third '
                'party. Manual entry works without SMS access.',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Agree & continue'),
          ),
        ],
      );
    },
  );

  return accepted == true;
}
