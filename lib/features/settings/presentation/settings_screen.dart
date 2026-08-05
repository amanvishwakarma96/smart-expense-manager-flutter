import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/security/app_lock_service.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/settings/presentation/backup_settings_card.dart';
import 'package:smart_expense_manager/features/settings/presentation/budget_alert_settings_card.dart';
import 'package:smart_expense_manager/features/settings/presentation/category_management_card.dart';
import 'package:smart_expense_manager/features/settings/presentation/merchant_rules_card.dart';
import 'package:smart_expense_manager/features/settings/presentation/recurring_transactions_card.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_inbox_import_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _lockEnabled = false;
  bool _loadingLock = true;
  bool _scanning = false;
  int _lockTimeoutMinutes = AppLockService.defaultTimeoutMinutes;

  @override
  void initState() {
    super.initState();
    _loadLockPreference();
  }

  Future<void> _loadLockPreference() async {
    final service = ref.read(appLockServiceProvider);
    final bool enabled = await service.isEnabled();
    final int timeout = await service.getTimeoutMinutes();
    if (mounted) {
      setState(() {
        _lockEnabled = enabled;
        _lockTimeoutMinutes = timeout;
        _loadingLock = false;
      });
    }
  }

  Future<void> _toggleLock(bool enabled) async {
    if (enabled) {
      final bool authenticated = await ref
          .read(appLockServiceProvider)
          .authenticate();
      if (!authenticated) {
        return;
      }
    }
    await ref.read(appLockServiceProvider).setEnabled(enabled);
    if (mounted) {
      setState(() => _lockEnabled = enabled);
      _message(
        enabled
            ? 'App lock is enabled and will apply when PiggyAI leaves the foreground.'
            : 'App lock is disabled.',
      );
    }
  }

  Future<void> _setLockTimeout(int? minutes) async {
    if (minutes == null) {
      return;
    }
    await ref.read(appLockServiceProvider).setTimeoutMinutes(minutes);
    if (mounted) {
      setState(() => _lockTimeoutMinutes = minutes);
      _message('Lock timing updated on this device.');
    }
  }

  String _lockTimeoutLabel(int minutes) {
    if (minutes == 0) {
      return 'Immediately';
    }
    return '$minutes minute${minutes == 1 ? '' : 's'}';
  }

  Future<void> _scanSms() async {
    if (!Platform.isAndroid) {
      _message('iOS does not expose the SMS inbox. Use manual entry instead.');
      return;
    }
    setState(() => _scanning = true);
    await Permission.notification.request();
    final SmsScanSummary summary = await ref
        .read(smsEngineCoordinatorProvider)
        .requestPermissionAndScanInbox();
    if (!mounted) {
      return;
    }
    setState(() => _scanning = false);
    switch (summary.permission) {
      case SmsPermissionResult.granted:
        _message(
          'Scanned ${summary.scanned} messages locally and added '
          '${summary.added} transaction${summary.added == 1 ? '' : 's'}.',
        );
      case SmsPermissionResult.denied:
        _message('SMS permission was denied. Manual entry still works.');
      case SmsPermissionResult.permanentlyDenied:
        _message('Enable SMS permission in system settings to scan messages.');
      case SmsPermissionResult.unsupported:
        _message('SMS scanning is available only on Android.');
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteAllData() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete all local financial data?'),
          content: const Text(
            'This permanently removes transactions, recurring items, goals, '
            'categories, rules, and the installation encryption key. '
            'There is no cloud copy.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(transactionRepositoryProvider).clearAll();
    await SecureCipherService.deleteInstallationKey();
    ref.read(resetRequiredProvider.notifier).requireRestart();
  }

  @override
  Widget build(BuildContext context) {
    final bool private = ref.watch(privacyModeProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppPalette.heroGradient,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.64),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.tune_rounded),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Make PiggyAI yours',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Text(
                        'Private controls, INR budgets, and friendly automation.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: 'Privacy',
            children: <Widget>[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hide financial amounts'),
                subtitle: const Text('Masks values throughout the app.'),
                value: private,
                onChanged: (bool value) {
                  ref.read(privacyModeProvider.notifier).setEnabled(value);
                },
              ),
              if (_loadingLock)
                const LinearProgressIndicator()
              else ...<Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Biometric or device lock'),
                  subtitle: const Text(
                    'Rechecks the preference whenever the app resumes.',
                  ),
                  value: _lockEnabled,
                  onChanged: _toggleLock,
                ),
                if (_lockEnabled) ...<Widget>[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: _lockTimeoutMinutes,
                    decoration: const InputDecoration(
                      labelText: 'Lock after backgrounding',
                    ),
                    items: AppLockService.supportedTimeoutMinutes
                        .map((int minutes) {
                          return DropdownMenuItem<int>(
                            value: minutes,
                            child: Text(_lockTimeoutLabel(minutes)),
                          );
                        })
                        .toList(growable: false),
                    onChanged: _setLockTimeout,
                  ),
                ],
              ],
            ],
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: 'On-device detection',
            children: <Widget>[
              const Text(
                'PiggyAI asks for SMS access only when you start a scan. '
                'Unmatched messages are never stored.',
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _scanning ? null : _scanSms,
                  icon: _scanning
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sms_rounded),
                  label: Text(
                    _scanning ? 'Scanning locally…' : 'Scan bank SMS',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const RecurringTransactionsCard(),
          const SizedBox(height: 14),
          const CategoryManagementCard(),
          const SizedBox(height: 14),
          const BudgetAlertSettingsCard(),
          const SizedBox(height: 14),
          const MerchantRulesCard(),
          const SizedBox(height: 14),
          const BackupSettingsCard(),
          const SizedBox(height: 14),
          _SettingsCard(
            title: 'Privacy contract',
            children: const <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.cloud_off_rounded),
                title: Text('No backend or cloud sync'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.wifi_off_rounded),
                title: Text('No Android internet permission'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.security_rounded),
                title: Text('Sensitive text is encrypted locally'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: 'Danger zone',
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: _deleteAllData,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Delete all financial data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}
