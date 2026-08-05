import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_inbox_import_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  bool _activatingSms = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingServiceProvider).markCompleted();
    if (mounted) {
      widget.onComplete();
    }
  }

  Future<void> _activateSms() async {
    if (!Platform.isAndroid) {
      await _finish();
      return;
    }

    setState(() => _activatingSms = true);
    final SmsScanSummary result = await ref
        .read(smsEngineCoordinatorProvider)
        .requestPermissionAndScanInbox();
    if (!mounted) {
      return;
    }
    setState(() => _activatingSms = false);

    switch (result.permission) {
      case SmsPermissionResult.granted:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Local scan complete. ${result.added} transaction'
              '${result.added == 1 ? '' : 's'} added for review.',
            ),
          ),
        );
      case SmsPermissionResult.denied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS access was declined. Manual entry still works.'),
          ),
        );
      case SmsPermissionResult.permanentlyDenied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS access can be enabled later from Settings.'),
          ),
        );
      case SmsPermissionResult.unsupported:
        break;
    }
    await _finish();
  }

  void _next() {
    if (_page == 2) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'PiggyAI',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(onPressed: _finish, child: const Text('Skip')),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (int value) => setState(() => _page = value),
                children: const <Widget>[
                  _OnboardingPage(
                    icon: Icons.shield_rounded,
                    color: AppPalette.lavender,
                    title: 'Your expenses stay yours',
                    message:
                        'PiggyAI has no backend, account, cloud sync, ads, or '
                        'analytics. Financial data is stored only on this device.',
                  ),
                  _OnboardingPage(
                    icon: Icons.auto_awesome_rounded,
                    color: AppPalette.mint,
                    title: 'Smart without cloud AI',
                    message:
                        'Bank alerts are parsed locally using transaction patterns '
                        'and your merchant rules. Unmatched SMS messages are not saved.',
                  ),
                  _OnboardingPage(
                    icon: Icons.tune_rounded,
                    color: AppPalette.peach,
                    title: 'You stay in control',
                    message:
                        'Every detected transaction enters a review inbox. Confirm, '
                        'edit, categorize, or remove it before budgets are updated.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(3, (int index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: index == _page ? 28 : 9,
                        height: 9,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _page
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  if (_page == 2 && Platform.isAndroid) ...<Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _activatingSms ? null : _activateSms,
                        icon: _activatingSms
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sms_rounded),
                        label: Text(
                          _activatingSms
                              ? 'Scanning locally…'
                              : 'Enable SMS detection',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _activatingSms ? null : _finish,
                      child: const Text('Continue with manual entry'),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _next,
                        child: Text(
                          _page == 2 ? 'Start privately' : 'Continue',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(44),
            ),
            child: Icon(icon, size: 72),
          ),
          const SizedBox(height: 34),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
