# Changelog

All notable changes to PiggyAI will be documented in this file.

## [0.9.0] - Unreleased

### Added

- Local possible-duplicate detection for SMS-derived pending transactions using
  matching account tails, an inclusive ₹1 amount tolerance, merchant substring
  or edit-distance similarity, and a five-minute timestamp window.
- A clear Possible duplicate badge in Pending Review while preserving explicit
  Confirm and Remove choices for the user.
- Encrypted merchant→category confidence mappings learned from confirmed manual
  category corrections.
- A Settings view for learned mappings with confidence counts plus per-mapping
  category editing and clearing.
- Read-only subscription detection across the last 90 days of confirmed debit
  history for weekly or monthly merchant+amount cadences with ±3 day jitter.
- Dismissible dashboard subscription suggestions that open the existing recurring
  editor with detected values prefilled.

### Changed

- Future pending SMS transactions use the highest-confidence learned category for
  the same merchant when no explicit merchant rule matches first.
- Pending category edits are marked for learning but do not increase confidence
  until the transaction is confirmed.
- The recurring editor is shared between Settings and dashboard subscription
  suggestions so setup follows one explicit Save flow.

### Security

- Duplicate and subscription analysis run deterministically on-device and never
  silently create, confirm, remove, or change a financial record.
- Newly learned merchant text is encrypted at rest with `SecureCipherService`;
  confidence metadata never requires a network or remote model.
- Subscription suggestions remain transient UI guidance and do not persist new
  sensitive merchant text or auto-create recurring templates.
- No backend, cloud service, analytics, telemetry, remote AI, or Android internet
  permission was introduced.

## [0.8.0] - Unreleased

### Added

- Fully local weekly money quests with either an INR spending cap or one to
  seven no-spend days.
- Monday-to-Sunday progress calculated from confirmed debit transactions only.
- Consecutive successful-week streaks and local reward badges for the first win,
  a three-week streak, five wins, and ten wins.
- A colorful dashboard quest card with live progress, edit/skip controls,
  encouraging guidance, and privacy-aware amount masking.
- Weekly challenge progress, streak, privacy, delete-all, and offline regression
  tests.

### Changed

- Expired weekly quests are finalized locally when PiggyAI starts.
- Full local-data deletion now clears motivational challenge history.
- Financial backup restore resets challenge history so old streak results are
  never evaluated against replaced transaction data.
- Weekly challenge behavior and privacy rules are documented separately under
  `docs/weekly-money-quests.md`.

### Security

- Weekly quests never modify transactions, budgets, recurring items, or savings
  goals and never block spending.
- Challenge history remains on-device and is intentionally excluded from
  financial backup exports.
- No backend, cloud sync, remote AI, analytics, telemetry, advertising, or
  Android internet permission was introduced.

## [0.7.0] - Unreleased

### Added

- Optional local reminders 1, 3, or 7 days before recurring expenses.
- Device-timezone reminder scheduling with reboot and app-replacement recovery.
- A playful safe-to-spend dashboard card that reserves upcoming scheduled bills.
- Upcoming-payment summaries with monthly and per-day spending guidance.
- Reminder timing, safe-to-spend, backup, privacy, and offline regression tests.

### Changed

- Recurring expense editing now includes explicit reminder opt-in and lead-time
  controls.
- Encrypted backup snapshots now use version 4 and include recurring reminder
  preferences while retaining restore compatibility with versions 1 through 3.
- Full local deletion and backup replacement cancel obsolete scheduled
  notifications.
- The dashboard now separates conservative safe-to-spend planning from the
  longer-range 30-day forecast.

### Security

- Bill reminder notifications never contain merchant, amount, account, balance,
  category, or raw SMS content.
- Reminders use inexact local scheduling and do not require exact-alarm access.
- Notification permission is requested only after explicit reminder opt-in.
- Safe-to-spend calculations never assume future income, never modify records,
  and run entirely on-device.
- No backend, cloud sync, remote AI, analytics, telemetry, or Android internet
  permission was introduced.

## [0.6.0] - Unreleased

### Added

- Custom category creation and editing with playful icons, colors, and monthly
  INR budgets.
- Safe category deletion that blocks removal while transactions, recurring
  templates, or merchant rules still reference the category.
- Full merchant-rule listing, editing, and deletion with longest-pattern-first
  matching for more specific local categorization.
- A deterministic 30-day spending forecast built from up to 60 days of
  non-recurring history and upcoming recurring templates.
- Forecast confidence labels, budget comparison, scheduled/flexible spending
  breakdowns, and privacy-aware values.
- Phase 7 forecast, management, privacy, and offline regression tests.

### Changed

- Settings now uses dedicated category and merchant-rule management cards rather
  than one-purpose budget and add-rule dialogs.
- The monthly insight section now includes a colorful next-30-days forecast.
- Category and merchant-rule streams are sorted for predictable, friendly UI.
- Merchant matching checks longer patterns before broader patterns.

### Security

- Forecast calculations are deterministic and run entirely on-device without a
  remote model, API, analytics, or network client.
- Privacy mode masks all forecast amounts.
- No Android internet permission, backend, cloud sync, or telemetry was added.

## [0.5.0] - Unreleased

### Added

- Encrypted local savings goals with editable targets, current progress, optional
  target dates, colors, and icons.
- One-tap local goal contributions with five playful milestone stars.
- A privacy-aware monthly cash-flow calendar built only from confirmed
  transactions.
- Daily transaction drill-down from calendar cells and month-level income,
  spending, and net summaries.
- A dedicated Goals destination with clear separation from transaction entry.
- Savings-goal and Phase 6 offline/privacy regression tests.

### Changed

- Encrypted backup snapshots now use version 3 and include savings goals while
  retaining restore compatibility with versions 1 and 2.
- Full local-data deletion now clears savings goals together with transactions,
  recurring schedules, rules, categories, and the installation key.
- The transaction floating action button is hidden on Goals and Settings so
  each destination keeps one obvious primary action.

### Security

- Goal names are encrypted before local persistence and decrypted only for
  on-device display or explicit password-protected backup creation.
- Cash-flow calendar calculations use only locally decrypted confirmed
  transactions and respect privacy amount masking.
- No backend, analytics, remote AI, cloud sync, or Android internet permission
  was introduced.

## [0.4.0] - Unreleased

### Added

- INR (`₹`, `en_IN`) as the explicit default application currency.
- Weekly and monthly recurring expenses or income with encrypted local
  templates.
- Due recurring occurrences enter the pending-review queue instead of being
  confirmed automatically.
- Recurring item creation, editing, pausing, resuming, and deletion in Settings.
- Editable confirmed transaction history and local transaction deletion.
- Monthly local insights for daily average, top category, and spending movement
  versus the previous month.
- Animated playful empty states, colorful summary cards, richer tactile
  controls, and a broader pastel design system.
- Recurring schedule and Phase 5 privacy-contract regression tests.

### Changed

- Encrypted backups now include recurring schedules and recurring-source flags.
- Version 1 encrypted snapshots remain restorable while new snapshots use
  version 2.
- Transaction entry, history, dashboard, and Settings now use the playful,
  friendly INR-first visual language.

### Security

- Recurring merchant text is encrypted before local persistence.
- Recurring occurrences never bypass the confirmation queue or affect budgets
  before user approval.
- Recurring templates remain fully local and are included only in explicitly
  created password-protected backups.

## [0.3.0] - Unreleased

### Added

- Password-protected encrypted backup export through the platform share sheet.
- Encrypted backup restore with full validation and explicit local-data replacement confirmation.
- Local category budget notifications at a configurable warning threshold and 100% usage.
- Expanded Indian bank SMS parsing for UPI, IMPS, NEFT, RTGS, ATM withdrawals, card transactions, refunds, and reversals.
- Backup encryption, budget-threshold, parser, and privacy-contract regression tests.

### Security

- Backups use a password-derived AES-256-GCM key and never export the installation encryption key.
- Restored sensitive fields are re-encrypted with the destination device's secure installation key.
- Backup files are accepted only after type, size, version, identity, reference, and payload validation.
- Temporary export files are deleted after the user-controlled share operation.
- Budget notifications never include merchant, account, balance, amount, or raw SMS details.

## [0.2.0] - Unreleased

### Added

- Privacy-first first-run onboarding with optional Android SMS activation.
- Searchable confirmed-transaction history with type and date filters.
- Configurable app-lock timeout options: immediately, 1, 5, or 15 minutes.
- Lifecycle-aware lock preference refresh when the app returns to foreground.
- Phase 3 privacy and security contract tests.

### Changed

- App-lock settings now apply after backgrounding without requiring an app restart.
- Flutter CI now validates every pull request instead of one hard-coded branch.

## [0.1.0] - 2026-08-04

### Added

- Offline-first Flutter application shell with feature-first architecture.
- Encrypted Isar-compatible transaction, category, budget, and merchant-rule data layer.
- Android bank-SMS parsing with encrypted native queuing and a pending-review inbox.
- Manual debit and credit entry for Android and iOS.
- Swipe-to-confirm, edit, categorize, and remove transaction workflow.
- Pastel dashboard with category-spending donut and seven-day cash-flow chart.
- Privacy amount masking, optional device authentication, secure Android screen flags, and full local-data deletion.
- Parser, encryption, and offline privacy-contract tests.
- Local bootstrap command for platform generation, code generation, analysis, and tests.

### Security

- No backend, cloud sync, telemetry, advertisements, or Android internet permission.
- Disabled Android backup and device-to-device transfer backup.
- Encrypted sensitive transaction fields with an installation-specific key.
- Disabled runtime font downloads.
- Erased original SMS text after transaction confirmation.
