import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smart_expense_manager/features/settings/presentation/settings_screen.dart';
import 'package:smart_expense_manager/features/transactions/presentation/manual_transaction_dialog.dart';
import 'package:smart_expense_manager/features/transactions/presentation/pending_transactions_screen.dart';

class PiggyAiApp extends ConsumerWidget {
  const PiggyAiApp({required this.lockEnabled, super.key});

  final bool lockEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool resetRequired = ref.watch(resetRequiredProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PiggyAI',
      theme: AppTheme.light(),
      home: resetRequired
          ? const _ResetCompleteScreen()
          : _AppLockGate(lockEnabled: lockEnabled, child: const HomeShell()),
    );
  }
}

class _AppLockGate extends ConsumerStatefulWidget {
  const _AppLockGate({required this.lockEnabled, required this.child});

  final bool lockEnabled;
  final Widget child;

  @override
  ConsumerState<_AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<_AppLockGate>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _unlocked = !widget.lockEnabled;
    if (widget.lockEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.lockEnabled) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    }
    if (state == AppLifecycleState.resumed &&
        _pausedAt != null &&
        DateTime.now().difference(_pausedAt!) > const Duration(minutes: 1)) {
      setState(() => _unlocked = false);
      _authenticate();
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
    if (_unlocked) {
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
              const Text('Authenticate locally to view your expenses.'),
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
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showManualTransactionDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
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
