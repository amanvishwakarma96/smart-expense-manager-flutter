import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
