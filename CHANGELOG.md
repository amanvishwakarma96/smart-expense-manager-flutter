# Changelog

All notable changes to PiggyAI will be documented in this file.

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
