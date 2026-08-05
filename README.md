# PiggyAI — Smart Expense Manager

PiggyAI is a playful, offline-first expense manager built with Flutter. It can
read transaction alerts on Android, parse them entirely on-device, place
detected expenses into a pending-review inbox, and update local budgets only
after confirmation.

## Privacy architecture

- No backend, account, cloud sync, advertising, analytics, or telemetry.
- No Android `INTERNET` permission.
- SMS and financial data never leave the device.
- Sensitive text is encrypted before persistence.
- Original SMS text is erased after transaction confirmation.
- Runtime Google Fonts downloads are explicitly disabled.
- Android backup and device-transfer backup are disabled.
- SMS access is optional; manual entry always remains available.
- iOS uses manual entry because iOS does not expose the SMS inbox to
  third-party apps.

## Current capabilities

- Privacy-first onboarding with optional Android SMS activation.
- Manual debit and credit entry on Android and iOS.
- Android bank-SMS detection with a pending review queue.
- Local merchant categorization rules and monthly category budgets.
- Searchable confirmed-transaction history with type and date filters.
- Category spending and seven-day cash-flow charts.
- Privacy amount masking and configurable biometric/device-lock timing.
- Full local financial-data deletion with encryption-key removal.

## Stack

- Flutter and Dart
- Riverpod
- Isar Community 3.x for embedded reactive storage
- `flutter_sms_inbox` and a native encrypted incoming-SMS queue
- `flutter_animate` and `fl_chart`
- Android Keystore / iOS Keychain through `flutter_secure_storage`
- AES-256-GCM field encryption with `cryptography`

## Local setup

Use Flutter 3.44 or newer, then run:

```bash
bash tool/bootstrap.sh
flutter run
```

The bootstrap command generates any missing official Android/iOS scaffold,
resolves packages, generates Isar schemas, formats the project, runs static
analysis, and executes tests.

To run the individual commands manually:

```bash
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
```

## Platform behavior

- **Android:** onboarding, manual entry, user-initiated inbox scan, incoming
  transaction SMS detection, pending review, history search, budgets, local
  rules, charts, privacy mode, and configurable app lock.
- **iOS:** onboarding, manual entry, history search, budgets, local rules,
  charts, privacy mode, and configurable app lock. Automatic SMS access is
  intentionally unavailable.

The app must remain usable in airplane mode after installation.
