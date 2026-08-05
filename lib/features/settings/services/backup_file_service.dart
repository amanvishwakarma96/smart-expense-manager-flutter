import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class BackupFileService {
  static const XTypeGroup _backupType = XTypeGroup(
    label: 'PiggyAI encrypted backup',
    extensions: <String>['piggybackup'],
    mimeTypes: <String>['application/octet-stream'],
    uniformTypeIdentifiers: <String>['public.data'],
  );

  Future<void> shareBackup(
    BackupExportResult backup, {
    Rect? sharePositionOrigin,
  }) async {
    final Directory temporaryDirectory = await getTemporaryDirectory();
    final File file = File('${temporaryDirectory.path}/${backup.fileName}');
    await file.writeAsBytes(backup.bytes, flush: true);
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'PiggyAI encrypted backup',
          subject: 'PiggyAI encrypted backup',
          text: 'Password-protected PiggyAI backup. Keep the password separate.',
          files: <XFile>[XFile(file.path)],
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<Uint8List?> pickBackup() async {
    final XFile? selected = await openFile(
      acceptedTypeGroups: const <XTypeGroup>[_backupType],
    );
    if (selected == null) {
      return null;
    }
    return Uint8List.fromList(await selected.readAsBytes());
  }
}
