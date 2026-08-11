import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: const <Widget>[
          _PolicySection(
            title: 'Privacy-first by design',
            body:
                'PiggyAI is an offline-first personal expense manager. It has no '
                'PiggyAI account, backend, cloud sync, advertising, analytics, '
                'telemetry, or remote AI service. Financial data is processed and '
                'kept on your device unless you explicitly export an encrypted backup.',
          ),
          _PolicySection(
            title: 'SMS access on Android',
            body:
                'SMS access is optional and is used only for the core money-management '
                'feature that detects bank and payment transaction alerts. PiggyAI can '
                'read recent inbox messages and receive new SMS alerts after you grant '
                'permission. Matching financial alerts become pending transactions for '
                'your review. Unmatched messages are not stored. Manual entry works '
                'without SMS permission. iOS does not expose the SMS inbox to PiggyAI.',
          ),
          _PolicySection(
            title: 'What stays on the device',
            body:
                'Confirmed and pending transactions, merchant names, account tails, '
                'transaction notes, categories, learned merchant rules, recurring '
                'items, goals, budgets, challenges, and related settings stay local. '
                'Sensitive persisted text follows PiggyAI’s encrypted-storage pattern.',
          ),
          _PolicySection(
            title: 'No collection or sharing',
            body:
                'PiggyAI does not transmit SMS text, financial records, identifiers, '
                'analytics events, advertising data, or diagnostics to the developer '
                'or to third parties. The Android app does not request the INTERNET '
                'permission.',
          ),
          _PolicySection(
            title: 'Encrypted backups',
            body:
                'Backups are created only when you request them. Backup contents are '
                'encrypted before export. If you choose a destination in the system '
                'share sheet, that destination is outside PiggyAI and is governed by '
                'the privacy terms of the app or service you choose.',
          ),
          _PolicySection(
            title: 'Security and retention',
            body:
                'Android cloud/device-transfer backup is disabled. PiggyAI can use '
                'biometric or device-lock protection and secure-screen controls. You '
                'control how long your records remain on the device and can delete all '
                'local financial data and the installation encryption key from Settings.',
          ),
          _PolicySection(
            title: 'Your choices',
            body:
                'You may decline SMS permission, revoke it later in system settings, '
                'use manual entry instead, hide financial amounts in the interface, '
                'disable app lock, export an encrypted backup, or permanently delete '
                'your local data.',
          ),
          _PolicySection(
            title: 'Scope and support',
            body:
                'This policy describes the PiggyAI mobile app. Store support and '
                'developer contact details are provided on the app’s official store '
                'listing and project repository. Effective date: 11 August 2026.',
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
