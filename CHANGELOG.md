# Changelog

All notable changes to PiggyAI will be documented in this file.

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
