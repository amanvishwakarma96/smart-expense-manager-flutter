import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/features/settings/services/budget_alert_service.dart';

class BudgetAlertSettingsCard extends ConsumerStatefulWidget {
  const BudgetAlertSettingsCard({super.key});

  @override
  ConsumerState<BudgetAlertSettingsCard> createState() =>
      _BudgetAlertSettingsCardState();
}

class _BudgetAlertSettingsCardState
    extends ConsumerState<BudgetAlertSettingsCard> {
  bool _loading = true;
  bool _enabled = false;
  int _threshold = BudgetAlertService.defaultThreshold;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final BudgetAlertService service = ref.read(budgetAlertServiceProvider);
    final bool enabled = await service.isEnabled();
    final int threshold = await service.getThreshold();
    if (mounted) {
      setState(() {
        _enabled = enabled;
        _threshold = threshold;
        _loading = false;
      });
    }
  }

  Future<void> _toggle(bool enabled) async {
    final BudgetAlertService service = ref.read(budgetAlertServiceProvider);
    if (enabled && !await service.requestPermission()) {
      _message('Notification permission was not granted.');
      return;
    }
    await service.setEnabled(enabled);
    if (mounted) {
      setState(() => _enabled = enabled);
      _message(
        enabled
            ? 'Budget alerts are enabled locally.'
            : 'Budget alerts are disabled.',
      );
    }
  }

  Future<void> _setThreshold(int? threshold) async {
    if (threshold == null) {
      return;
    }
    await ref.read(budgetAlertServiceProvider).setThreshold(threshold);
    if (mounted) {
      setState(() => _threshold = threshold);
      _message('Budget warning threshold updated.');
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              'Budget alerts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Notifications are generated on-device and never include '
              'merchant, account, or SMS details.',
            ),
            const SizedBox(height: 10),
            if (_loading)
              const LinearProgressIndicator()
            else ...<Widget>[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notify near monthly limits'),
                subtitle: const Text(
                  'Alerts once at the warning level and again at 100%.',
                ),
                value: _enabled,
                onChanged: _toggle,
              ),
              if (_enabled)
                DropdownButtonFormField<int>(
                  initialValue: _threshold,
                  decoration: const InputDecoration(
                    labelText: 'Warning threshold',
                  ),
                  items: BudgetAlertService.supportedThresholds.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value% used'),
                    );
                  }).toList(growable: false),
                  onChanged: _setThreshold,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
