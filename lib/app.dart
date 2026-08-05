import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smart_expense_manager/features/goals/presentation/goals_calendar_screen.dart';
import 'package:smart_expense_manager/features/settings/presentation/onboarding_screen.dart';
import 'package:smart_expense_manager/features/settings/presentation/settings_screen.dart';
import 'package:smart_expense_manager/features/transactions/presentation/manual_transaction_dialog.dart';
import 'package:smart_expense_manager/features/transactions/presentation/pending_transactions_screen.dart';
import 'package:smart_expense_manager/features/transactions/presentation/transaction_history_screen.dart';

class PiggyAiApp extends ConsumerWidget {
  const PiggyAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool resetRequired = ref.watch(resetRequiredProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PiggyAI',
      theme: AppTheme.light(),
      home: resetRequired
          ? const _ResetCompleteScreen()
          : const _OnboardingGate(child: _AppLockGate(child: HomeShell())),
    );
  }
}

class _OnboardingGate extends ConsumerStatefulWidget {
  const _OnboardingGate({required this.child});

  final Widget child;

  @override
  ConsumerState<_OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends ConsumerState<_OnboardingGate> {
  bool? _completed;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bool completed = await ref
        .read(onboardingServiceProvider)
        .isCompleted();
    if (mounted) {
      setState(() => _completed = completed);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_completed!) {
      return OnboardingScreen(
        onComplete: () => setState(() => _completed = true),
      );
    }
    return widget.child;
  }
}

class _AppLockGate extends ConsumerStatefulWidget {
  const _AppLockGate({required this.child});

  final Widget child;

  @override
  ConsumerState<_AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<_AppLockGate>
    with WidgetsBindingObserver {
  bool _loading = true;
  bool _lockEnabled = false;
  bool _unlocked = false;
  int _timeoutMinutes = 1;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadInitialPreferences());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _pausedAt ??= DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      unawaited(_handleResume());
    }
  }

  Future<void> _loadInitialPreferences() async {
    final service = ref.read(appLockServiceProvider);
    final bool enabled = await service.isEnabled();
    final int timeout = await service.getTimeoutMinutes();
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _lockEnabled = enabled;
      _timeoutMinutes = timeout;
      _unlocked = !enabled;
    });
    if (enabled) {
      await _authenticate();
    }
  }

  Future<void> _handleResume() async {
    final service = ref.read(appLockServiceProvider);
    final bool enabled = await service.isEnabled();
    final int timeout = await service.getTimeoutMinutes();
    if (!mounted) {
      return;
    }

    if (!enabled) {
      setState(() {
        _lockEnabled = false;
        _timeoutMinutes = timeout;
        _unlocked = true;
        _pausedAt = null;
      });
      return;
    }

    final DateTime? pausedAt = _pausedAt;
    final bool timeoutReached =
        pausedAt != null &&
        DateTime.now().difference(pausedAt) >= Duration(minutes: timeout);
    setState(() {
      _lockEnabled = true;
      _timeoutMinutes = timeout;
      _pausedAt = null;
      if (timeoutReached) {
        _unlocked = false;
      }
    });
    if (timeoutReached) {
      await _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final bool authenticated = await ref
        .read(appLockServiceProvider)
        .authenticate();
    if (mounted) {
      setState(() => _unlocked = authenticated);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_lockEnabled || _unlocked) {
      return widget.child;
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.lock_rounded, size: 68),
              const SizedBox(height: 18),
              Text(
                'PiggyAI is locked',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _timeoutMinutes == 0
                    ? 'PiggyAI locks whenever it leaves the foreground.'
                    : 'PiggyAI locked after $_timeoutMinutes minute'
                          '${_timeoutMinutes == 1 ? '' : 's'} in the background.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<Widget> _screens = <Widget>[
    DashboardScreen(),
    PendingTransactionsScreen(),
    TransactionHistoryScreen(),
    GoalsCalendarScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: _index <= 2
          ? FloatingActionButton.extended(
              onPressed: () => showManualTransactionDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.inbox_rounded),
            label: 'Review',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_rounded),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _ResetCompleteScreen extends StatelessWidget {
  const _ResetCompleteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.check_circle_rounded, size: 72),
              SizedBox(height: 18),
              Text(
                'Local financial data deleted',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Close and reopen PiggyAI to create a new encryption key.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
