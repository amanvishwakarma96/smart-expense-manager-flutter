# PiggyAI — Smart Expense Manager

PiggyAI is an offline-first expense manager built with Flutter. It detects transaction alerts from bank SMS messages on Android, parses them entirely on-device, places matches into a pending-review queue, and updates budgets only after user confirmation.

## Privacy promise

- No backend or cloud database
- No analytics, advertising, or telemetry SDKs
- No raw SMS or financial data leaves the device
- No Android `INTERNET` permission
- Manual transaction entry remains available without SMS permission

## Planned stack

Flutter, Riverpod, Isar, `flutter_sms_inbox`, `permission_handler`, `flutter_animate`, and `fl_chart`.

> Development is in progress on a milestone-based feature branch.
