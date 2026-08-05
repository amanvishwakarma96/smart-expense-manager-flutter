import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class BackupSettingsCard extends ConsumerStatefulWidget {
  const BackupSettingsCard({super.key});

  @override
  ConsumerState<BackupSettingsCard> createState() => _BackupSettingsCardState();
}

class _BackupSettingsCardState extends ConsumerState<BackupSettingsCard> {
  bool _busy = false;

  Future<void> _exportBackup(Rect? sharePositionOrigin) async {
    final String? password = await _promptPassword(
      title: 'Create encrypted backup',
      confirmPassword: true,
    );
    if (password == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final BackupExportResult backup = await ref
          .read(localBackupServiceProvider)
          .createEncryptedBackup(password);
      await ref
          .read(backupFileServiceProvider)
          .shareBackup(backup, sharePositionOrigin: sharePositionOrigin);
      if (mounted) {
        _message(
          'Encrypted ${backup.transactions} transaction'
          '${backup.transactions == 1 ? '' : 's'} for user-controlled sharing.',
        );
      }
    } on ArgumentError catch (error) {
      if (mounted) {
        _message(error.message?.toString() ?? 'Use a stronger password.');
      }
    } on Object {
      if (mounted) {
        _message('Could not create the encrypted backup.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    Uint8List? bytes;
    try {
      bytes = await ref.read(backupFileServiceProvider).pickBackup();
    } on FormatException catch (error) {
      if (mounted) {
        _message(error.message.toString());
      }
      return;
    } on Object {
      if (mounted) {
        _message('Could not open the selected backup file.');
      }
      return;
    }
    if (bytes == null || !mounted) {
      return;
    }

    final String? password = await _promptPassword(
      title: 'Unlock backup',
      confirmPassword: false,
    );
    if (password == null || !mounted) {
      return;
    }
    final bool replace = await _confirmReplacement();
    if (!replace || !mounted) {
      return;
    }

    setState(() => _busy = true);
    try {
      final BackupSnapshotSummary summary = await ref
          .read(localBackupServiceProvider)
          .restoreEncryptedBackup(bytes: bytes, password: password);
      if (mounted) {
        _message(
          'Restored ${summary.transactions} transaction'
          '${summary.transactions == 1 ? '' : 's'} locally.',
        );
      }
    } on BackupPasswordException {
      if (mounted) {
        _message('Incorrect password or damaged backup file.');
      }
    } on FormatException catch (error) {
      if (mounted) {
        _message(error.message.toString());
      }
    } on Object {
      if (mounted) {
        _message('Could not restore this PiggyAI backup.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<String?> _promptPassword({
    required String title,
    required bool confirmPassword,
  }) async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmationController =
        TextEditingController();
    bool obscure = true;
    String? errorText;

    final String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            void submit() {
              final String password = passwordController.text;
              if (password.length < 8) {
                setDialogState(() => errorText = 'Use at least 8 characters.');
                return;
              }
              if (confirmPassword && password != confirmationController.text) {
                setDialogState(() => errorText = 'Passwords do not match.');
                return;
              }
              Navigator.of(dialogContext).pop(password);
            }

            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'The password is never stored. A forgotten password '
                      'cannot be recovered.',
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: obscure,
                      autofocus: true,
                      onSubmitted: (_) {
                        if (!confirmPassword) {
                          submit();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Backup password',
                        errorText: errorText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setDialogState(() => obscure = !obscure);
                          },
                          icon: Icon(
                            obscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                        ),
                      ),
                    ),
                    if (confirmPassword) ...<Widget>[
                      const SizedBox(height: 12),
                      TextField(
                        controller: confirmationController,
                        obscureText: obscure,
                        onSubmitted: (_) => submit(),
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: submit,
                  child: Text(confirmPassword ? 'Create backup' : 'Unlock'),
                ),
              ],
            );
          },
        );
      },
    );
    passwordController.dispose();
    confirmationController.dispose();
    return result;
  }

  Future<bool> _confirmReplacement() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Replace local financial data?'),
              content: const Text(
                'Restoring permanently replaces the current transactions, '
                'categories, budgets, and merchant rules on this device.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Replace and restore'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Rect? _shareOrigin(BuildContext context) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Encrypted local backup',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Export only when you choose. Backups are protected by your '
              'password and contain no installation encryption key.',
            ),
            const SizedBox(height: 14),
            if (_busy)
              const LinearProgressIndicator()
            else ...<Widget>[
              Builder(
                builder: (BuildContext shareContext) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          _exportBackup(_shareOrigin(shareContext)),
                      icon: const Icon(Icons.lock_rounded),
                      label: const Text('Create encrypted backup'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _restoreBackup,
                  icon: const Icon(Icons.restore_rounded),
                  label: const Text('Restore encrypted backup'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
