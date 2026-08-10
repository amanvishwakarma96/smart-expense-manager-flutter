# PiggyAI — Smart Expense Manager

PiggyAI is a playful, offline-first expense manager built with Flutter. It can
read transaction alerts on Android, parse them entirely on-device, place
detected expenses into a pending-review inbox, and update local budgets only
after confirmation.

## Product defaults

- Default currency: Indian Rupee (`INR`, `₹`) with the `en_IN` locale.
- Visual style: playful, friendly, tactile, colorful, and easy to understand.
- Data policy: local-only by default, with no backend or automatic sync.

## Privacy architecture

- No backend, account, cloud sync, advertising, analytics, or telemetry.
- No Android `INTERNET` permission.
- SMS and financial data never leave the device unless the user explicitly
  creates and shares a password-protected backup.
- Sensitive text, including merchant and savings-goal names, is encrypted before
  persistence.
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
- Local possible-duplicate detection that warns in Review without silently
  dropping or confirming either transaction.
- Indian UPI, IMPS, NEFT, RTGS, ATM, card, refund, and reversal parsing rules.
- Weekly and monthly recurring expenses or income that always enter review
  before they affect budgets.
- Optional local reminders 1, 3, or 7 days before recurring expenses.
- A conservative safe-to-spend plan that reserves upcoming scheduled bills.
- Playful weekly money quests with live progress, streaks, and local reward
  badges.
- Editable confirmed transaction history with local deletion controls.
- Custom colorful categories with editable monthly INR budgets.
- Full local merchant-rule creation, editing, deletion, and specific-first
  matching.
- Local budget-threshold notifications with privacy-safe notification text.
- Searchable confirmed-transaction history with type and date filters.
- Monthly local insights including daily average, top category, and
  month-over-month spending movement.
- A deterministic 30-day local forecast combining recent flexible spending with
  upcoming recurring items.
- Encrypted savings goals with contribution progress, optional dates, colors,
  icons, and five playful milestone stars.
- A monthly cash-flow calendar with privacy masking and daily confirmed-
  transaction drill-down.
- Category spending and seven-day cash-flow charts.
- Animated pastel cards, tactile controls, colorful summaries, and friendly
  empty states.
- Privacy amount masking and configurable biometric/device-lock timing.
- Password-protected encrypted local backup export and restore, including
  recurring schedules, reminder preferences, and savings goals.
- Full local financial-data deletion with reminder cancellation and
  encryption-key removal.

## Bill reminders

- Reminders are optional and available only for recurring expenses.
- The user explicitly enables each reminder and chooses 1, 3, or 7 days before
  the due date.
- Reminders are scheduled for approximately 9:00 AM in the device timezone.
- PiggyAI uses inexact local scheduling and does not request exact-alarm access.
- Notification permission is requested only when the user saves an enabled
  reminder.
- Lock-screen notification text never contains the merchant, amount, account,
  balance, category, or raw SMS content.
- Pausing or deleting a recurring item cancels its reminder. Startup, app
  replacement, and device reboot restore eligible reminders.

## Safe-to-spend planning

- The dashboard reserves every active recurring debit due before month-end.
- The estimate uses confirmed current-month income, confirmed spending, and
  remaining category budgets.
- When both income and budgets are available, PiggyAI uses the lower remaining
  amount after scheduled bills.
- Future or recurring income is never assumed.
- The card shows the remaining monthly amount, a daily guide, and the nearest
  upcoming payments.
- Privacy mode masks the safe amount, daily amount, bill reserve, and individual
  upcoming values.
- The calculation is guidance only and never changes transactions, budgets,
  recurring items, or goals.

## Weekly money quests

- A quest covers one local Monday-to-Sunday week and uses confirmed debit
  transactions only.
- Users can choose a weekly INR spending cap or a target of one to seven
  no-spend days.
- The dashboard shows live progress and encouraging guidance; a quest never
  blocks spending or changes financial records.
- Completed quests can build a consecutive-week streak and unlock local badges
  for the first win, a three-week streak, five wins, and ten wins.
- Spending-cap values obey the global privacy-masking toggle.
- Quest history remains local motivational metadata and is intentionally not
  exported in financial backups.
- Restoring a financial backup resets quest history so old streaks are never
  evaluated against replaced transaction data.

## Local spending forecast

- The forecast is deterministic and runs entirely on the device; it is not a
  cloud AI prediction.
- It uses up to 60 recent days of confirmed, non-recurring activity to estimate
  flexible spending for the next 30 days.
- Active weekly and monthly recurring templates are added separately so they are
  not double counted.
- The card compares projected spending with category budgets and labels its
  confidence according to the amount of local history available.
- Privacy mode masks every projected amount.
- Estimates are guidance only and never modify transactions, budgets, or goals.

## Categories and merchant rules

- Users can create or edit category names, icons, colors, and monthly budgets.
- A category cannot be deleted while a transaction, recurring item, or merchant
  rule references it, and PiggyAI always keeps at least one category.
- Merchant rules can be added, edited, and deleted from Settings.
- Longer merchant patterns are checked before broader patterns so specific rules
  win, for example `amazon prime` before `amazon`.
- Categories and merchant rules remain local and are already included in
  explicit encrypted backups.

## Savings goals and rewards

- Goal names are encrypted using the installation-specific key.
- Users can set a target, record an existing balance, add contributions, choose
  a target date, and select a playful color and icon.
- Progress unlocks five local milestone stars at started, 25%, 50%, 75%, and
  100% completion.
- Goal amounts respect the global privacy-masking toggle.
- Archived goals leave the active list but remain locally stored and included in
  explicit encrypted backups.

## Cash-flow calendar

- Calendar cells are calculated only from confirmed local transactions.
- Debit days, credit days, and mixed days use different pastel signals.
- Tapping a populated day opens an on-device list of that day's transactions.
- Monthly income, spending, and net totals respect privacy masking.
- Pending transactions never appear until the user confirms them.

## Recurring transaction behavior

- Recurring templates are stored locally with encrypted merchant text.
- Weekly and monthly schedules are supported.
- Due occurrences become pending-review transactions rather than being
  confirmed automatically.
- Month-end schedules safely clamp to the final available day of shorter
  months.
- Users can edit, pause, resume, delete, or optionally remind themselves about
  recurring expenses from Settings.

## Encrypted backup behavior

- Backup creation happens only after explicit user action.
- The user supplies a password of at least eight characters.
- The snapshot is protected using PBKDF2-HMAC-SHA256 and AES-256-GCM.
- The installation encryption key is never placed in the backup.
- A restore validates the encrypted envelope and snapshot before replacing any
  local database collections.
- Sensitive fields are re-encrypted using the destination installation's key.
- Snapshot version 4 includes recurring schedules, reminder preferences, and
  savings goals, while versions 1, 2, and 3 remain restorable.
- Restoring or deleting data cancels obsolete scheduled reminders and rebuilds
  only the reminders represented by the resulting local data.
- Weekly quest history is excluded from financial backup files and is reset
  after restore so motivational results cannot become inconsistent.
- Temporary export files are deleted after the platform share flow completes.
- A forgotten backup password cannot be recovered because no password or cloud
  copy is stored.

## Stack

- Flutter and Dart
- Riverpod
- Isar Community 3.x for embedded reactive storage
- `flutter_sms_inbox` and a native encrypted incoming-SMS queue
- `flutter_animate` and `fl_chart`
- Android Keystore / iOS Keychain through `flutter_secure_storage`
- AES-256-GCM field encryption with `cryptography`
- Native file selection and share-sheet export for user-controlled backups
- Local notifications with device-timezone scheduling for privacy-safe alerts

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
  transaction SMS detection, pending review, recurring transactions, local bill
  reminders, safe-to-spend planning, weekly money quests, editable history,
  custom categories, merchant rules, local forecast, savings goals, cash-flow
  calendar, budgets, local alerts, encrypted backup/restore, insights, charts,
  privacy mode, and configurable app lock.
- **iOS:** onboarding, manual entry, recurring transactions, local bill
  reminders, safe-to-spend planning, weekly money quests, editable history,
  custom categories, merchant rules, local forecast, savings goals, cash-flow
  calendar, budgets, local alerts, encrypted backup/restore, insights, charts,
  privacy mode, and configurable app lock. Automatic SMS access is intentionally
  unavailable.

The app must remain usable in airplane mode after installation.
