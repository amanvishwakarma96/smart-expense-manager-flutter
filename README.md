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
- Sensitive text, including merchant, savings-goal, debt counterparty, and debt
  note text, is encrypted before persistence.
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
- Confidence-based merchant/category learning from confirmed corrections, with
  encrypted merchant text and editable/clearable learned mappings in Settings.
- Read-only subscription suggestions from 90 days of confirmed debit history;
  accepting a suggestion opens the existing recurring editor without auto-saving.
- A non-blocking 30-day encrypted-backup reminder in Settings with a local
  90-day snooze option.
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
- A private Debt & Loan Manager for borrowed money, money lent to others, and
  formal loans, with outstanding balances, repayment progress, optional due
  reminders, and explicit confirmed-transaction linking.
- A deterministic EMI & Repayment Planner with weekly/monthly schedules, next
  due and overdue guidance, payoff estimates, and optional APR-based
  principal/interest projections without auto-posting payments.
- A combined Plan destination for Goals & Calendar, Debts & Loans, and repayment
  planning.
- Category spending and seven-day cash-flow charts.
- Animated pastel cards, tactile controls, colorful summaries, and friendly
  empty states.
- Privacy amount masking and configurable biometric/device-lock timing.
- Password-protected encrypted local backup export and restore, including
  recurring schedules, reminder preferences, savings goals, debt/loan ledgers,
  and repayment plans.
- Full local financial-data deletion with reminder cancellation and
  encryption-key removal.

## Debt and loan manager

- Users explicitly create one of three local ledger types: Borrowed money, Money
  lent, or Loan. PiggyAI never creates a debt record automatically from SMS.
- Counterparty names and private notes are encrypted with the installation key
  before they are written to Isar.
- Opening outstanding balance can be the amount owed today, or ₹0 when the user
  plans to link the original confirmed principal transaction instead.
- Manual ledger entries can increase a tracked balance or record a repayment;
  they do not create or edit a bank transaction.
- Compatible confirmed transactions can be linked only after the user chooses
  the transaction and confirms the link. The source transaction remains intact.
- Borrowed-money credits and formal-loan credits stay distinct, while `Lent money
  repaid` records money returned by a borrower without counting it as income.
- Optional due reminders are local, use inexact scheduling, and contain no name,
  amount, account, balance, category, note, or raw SMS content.
- Privacy mode masks debt/loan amounts throughout Plan and detail screens.

## EMI and repayment planner

- A repayment plan attaches to an existing debt/loan ledger and stores only
  cadence, installment, optional APR, dates, numeric baselines, pause state, and
  local timestamps.
- Weekly plans advance every seven days. Monthly plans keep their original
  due-day anchor and clamp only for shorter months, for example 31 Jan → 28/29
  Feb → 31 Mar.
- PiggyAI compares recorded repayment progress with installments expected by
  today and can show On track, Due today, Behind plan, Settled, or Payment too
  low.
- Optional APR is used only for a local estimate of principal/interest split and
  payoff timing; it is not a lender statement and does not model every fee,
  compounding rule, penalty, or floating-rate change.
- Editing a plan replans from the current debt balance and current repayment
  total without rewriting historical transactions or debt-ledger entries.
- Saving, pausing, resuming, or deleting a plan never creates a transaction,
  marks a payment paid, or changes a debt balance. Real repayments still require
  the explicit manual-entry or confirmed-transaction-link flow.
- Privacy mode masks repayment-plan amounts and projections.

## Backup reminder

- The reminder appears in Settings only when at least one confirmed transaction
  exists and no successful backup is recorded or the last one is 30+ days old.
- “Don't remind me for 90 days” stores a local snooze timestamp and keeps the
  reminder hidden until that time has passed.
- Reminder storage is an unencrypted local JSON file containing only the last
  successful backup timestamp and snooze-until timestamp; it contains no
  transaction, merchant, amount, account, category, password, or encryption-key
  data.
- A backup is marked successful only after encrypted backup creation and the
  user-controlled platform share flow return without error.
- The reminder is non-blocking and never creates, restores, edits, or deletes
  financial records.

## Subscription suggestions

- The detector reads only the last 90 days of confirmed, non-recurring debit
  transactions already stored on the device.
- At least three matching merchant-and-amount occurrences are required.
- Weekly cadence accepts consecutive intervals around seven days with ±3 days of
  jitter; monthly cadence uses thirty days with the same tolerance.
- A matching existing recurring template suppresses the suggestion.
- Dashboard suggestions can be dismissed for the current app session.
- “Set up as recurring” opens the same recurring editor used in Settings with
  merchant, amount, cadence, category, and next expected date prefilled.
- The detector never creates or edits a recurring item; only the editor's
  explicit Save action does that.

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
- A category cannot be deleted while a transaction, recurring item, explicit
  merchant rule, or learned merchant mapping references it.
- Merchant rules can be added, edited, and deleted from Settings.
- Longer explicit merchant patterns are checked before broader patterns so
  specific rules win, for example `amazon prime` before `amazon`.
- Confirmed manual category corrections build a separate local confidence score;
  among learned mappings for the same merchant, the highest-confidence category
  is pre-selected for future pending transactions.
- Learned merchant text is AES-GCM encrypted at rest and each learned mapping can
  be edited or cleared from Settings.

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
- Snapshot version 7 preserves semantic transaction purpose and includes
  recurring schedules, reminder preferences, savings goals, debt/loan accounts,
  debt-ledger entries, and repayment-plan metadata; versions 1 through 6 remain
  restorable.
- Restoring a v1-v5 snapshot clears current debt/loan ledgers because those
  formats predate debt storage; restoring any v1-v6 snapshot clears newer
  repayment plans rather than merging them with older financial state.
- The read-only restore preview shows debt-ledger and repayment-plan counts before
  the user confirms destructive replacement.
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
  custom categories, merchant rules, local forecast, subscription suggestions,
  backup reminder, savings goals, cash-flow calendar, private debt/loan ledgers,
  generic debt due reminders, EMI/repayment planning, budgets, local alerts,
  encrypted backup/restore, insights, charts, privacy mode, and configurable app
  lock.
- **iOS:** onboarding, manual entry, recurring transactions, local bill
  reminders, safe-to-spend planning, weekly money quests, editable history,
  custom categories, merchant rules, local forecast, subscription suggestions,
  backup reminder, savings goals, cash-flow calendar, private debt/loan ledgers,
  generic debt due reminders, EMI/repayment planning, budgets, local alerts,
  encrypted backup/restore, insights, charts, privacy mode, and configurable app
  lock. Automatic SMS access is intentionally unavailable.

The app must remain usable in airplane mode after installation.
