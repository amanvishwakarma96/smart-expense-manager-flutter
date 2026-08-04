import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_inbox_import_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _lockEnabled = false;
  bool _loadingLock = true;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _loadLockPreference();
  }

  Future<void> _loadLockPreference() async {
    final bool enabled = await ref.read(appLockServiceProvider).isEnabled();
    if (mounted) {
      setState(() {
        _lockEnabled = enabled;
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
      _message('The lock preference will fully apply after reopening PiggyAI.');
    }
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

  Future<void> _editBudget(CategoryModel category) async {
    final TextEditingController controller = TextEditingController(
      text: category.monthlyBudgetLimit.toStringAsFixed(0),
    );
    final double? value = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${category.name} budget'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(prefixText: '₹ '),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(double.tryParse(controller.text.trim())),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (value != null && value >= 0) {
      await ref
          .read(categoryRepositoryProvider)
          .updateBudget(category.id, value);
    }
  }

  Future<void> _addMerchantRule() async {
    final List<CategoryModel> categories = await ref
        .read(categoryRepositoryProvider)
        .getAll();
    if (!mounted || categories.isEmpty) {
      return;
    }
    final TextEditingController patternController = TextEditingController();
    int categoryId = categories.first.id;
    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Local merchant rule'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: patternController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant pattern',
                      hintText: 'Example: SWIGGY',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: categoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories
                        .map((CategoryModel item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        })
                        .toList(growable: false),
                    onChanged: (int? value) {
                      if (value != null) {
                        setDialogState(() => categoryId = value);
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    final String pattern = patternController.text.trim();
    patternController.dispose();
    if (save == true && pattern.isNotEmpty) {
      await ref
          .read(merchantRuleRepositoryProvider)
          .saveRule(merchantPattern: pattern, categoryId: categoryId);
      if (mounted) {
        _message('Merchant rule saved only on this device.');
      }
    }
  }

  Future<void> _deleteAllData() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete all local financial data?'),
          content: const Text(
            'This permanently removes transactions, categories, rules, and '
            'the installation encryption key. There is no cloud copy.',
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
    final AsyncValue<List<CategoryModel>> categories = ref.watch(
      categoriesProvider,
    );
    final bool private = ref.watch(privacyModeProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          Text(
            'Settings',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
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
              else
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Biometric or device lock'),
                  subtitle: const Text('Locks after one minute in background.'),
                  value: _lockEnabled,
                  onChanged: _toggleLock,
                ),
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
          _SettingsCard(
            title: 'Monthly budgets',
            children: <Widget>[
              categories.when(
                loading: () => const LinearProgressIndicator(),
                error: (Object error, StackTrace stackTrace) =>
                    const Text('Could not load categories.'),
                data: (List<CategoryModel> items) {
                  return Column(
                    children: items
                        .map((CategoryModel category) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: colorFromHex(category.hexColor),
                              child: const Icon(Icons.category_rounded),
                            ),
                            title: Text(category.name),
                            subtitle: Text(
                              '${inrCurrency.format(category.monthlyBudgetLimit)} / month',
                            ),
                            trailing: IconButton(
                              onPressed: () => _editBudget(category),
                              icon: const Icon(Icons.edit_rounded),
                            ),
                          );
                        })
                        .toList(growable: false),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: 'Smart categorization',
            children: <Widget>[
              const Text(
                'Merchant matching uses local rules, not a cloud AI service.',
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _addMerchantRule,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Add merchant rule'),
              ),
            ],
          ),
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
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}
