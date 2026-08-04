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
- Android backup and device-transfer backup are disabled.
- SMS access is optional; manual entry always remains available.
- iOS uses manual entry and user-initiated text parsing because iOS does not
  expose the SMS inbox to third-party apps.

## Stack

- Flutter and Dart
- Riverpod
- Isar Community 3.x, the maintained Isar-compatible local database fork
- `flutter_sms_inbox` and a native encrypted incoming-SMS queue
- `flutter_animate` and `fl_chart`
- Android Keystore / iOS Keychain through `flutter_secure_storage`
- AES-256-GCM field encryption with `cryptography`

## Local setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The app must remain usable in airplane mode after installation.
