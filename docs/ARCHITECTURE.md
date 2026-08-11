# Architecture

PiggyAI follows a feature-first architecture and keeps all runtime data local.

```text
lib/
├── core/
│   ├── database/
│   ├── providers/
│   ├── security/
│   ├── theme/
│   ├── utils/
│   └── widgets/
└── features/
    ├── challenges/
    ├── dashboard/
    ├── goals/
    ├── settings/
    ├── sms_engine/
    └── transactions/
```

## Data flow

1. Android receives a transaction-looking SMS.
2. Native Kotlin performs a coarse keyword and amount filter.
3. The message is encrypted with an Android Keystore AES-GCM key and queued in private `SharedPreferences`.
4. Flutter drains the queue through a method channel.
5. Dart performs detailed parsing, checks explicit merchant rules, then checks encrypted merchant→category confidence learned only from confirmed manual corrections before falling back to deterministic local category inference.
6. Before a new SMS-derived record is queued, local duplicate analysis compares account tail, amount, merchant similarity, and a five-minute timestamp window against pending and confirmed records.
7. Sensitive text fields are encrypted again with an installation-specific key stored through `flutter_secure_storage`; learned merchant text uses this same field-encryption service.
8. Isar stores the pending transaction locally, including an optional numeric `possibleDuplicateOf` reference when the detector finds a likely match.
9. The user confirms, edits, categorizes, or discards the transaction. A manually corrected category increases its encrypted merchant mapping confidence only after confirmation; duplicate warnings never remove or confirm a record automatically.
10. Dashboard analysis reads confirmed local history. Subscription detection groups the last 90 days of non-recurring confirmed debits by normalized merchant and amount, then checks consecutive seven- or thirty-day intervals with a ±3 day tolerance. Existing recurring templates are excluded.
11. Subscription suggestions are transient UI guidance. Dismissing a suggestion changes only dashboard state; accepting one opens the shared recurring editor with prefilled fields, and no recurring record is created until the user explicitly presses Save.
12. Backup reminder metadata is separate from financial storage. A tiny unencrypted local JSON file contains only `lastSuccessfulBackupAt` and `snoozedUntil` timestamps. With at least one confirmed transaction, the Settings nudge appears when no backup is recorded or the last successful export is at least 30 days old, unless a 90-day snooze is still active.
13. The successful-backup timestamp is recorded only after the encrypted backup has been created and the platform share flow reports success. Reminder metadata never participates in transaction, budget, goal, or recurring-item calculations.
14. Riverpod streams refresh dashboard, settings, and budget views.

No step sends SMS or financial data over a network.

## SMS permission and consent boundary

Android SMS access is optional and supports PiggyAI's core SMS-based money-management feature.

- The production manifest requests only `READ_SMS` and `RECEIVE_SMS` from the SMS/Call Log permission families.
- Before first-time runtime SMS permission, `sms_engine/presentation/sms_permission_disclosure.dart` presents a non-dismissible policy disclosure explaining what is accessed, why it is needed, background receipt behavior, local processing/storage behavior, no off-device transmission, and the manual-entry alternative.
- The disclosure requires an explicit **Agree & continue** action. **Not now** exits the flow without requesting permission. Back/navigation away is never treated as consent.
- If SMS permission is already granted, the disclosure is not repeated for every manual scan.
- Onboarding and Settings both use the same disclosure helper immediately before `requestPermissionAndScanInbox()`.
- Manual transaction entry remains independent of SMS permission.
- The manual SMS scan flow does not request notification permission; notification access is requested only by the separate reminder feature when the user explicitly enables a reminder.

## Backup restore boundary

Encrypted restore has two explicit phases:

1. `BackupInspectionService` decrypts the selected backup in memory, validates the supported snapshot version and basic collection shape, and returns only a summary containing the backup date/version and record counts. It has no Isar dependency and performs no writes.
2. Settings shows that summary before the destructive replacement dialog. Only after the user explicitly chooses **Replace and restore** does `LocalBackupService.restoreEncryptedBackup` perform its existing deep validation and local replacement transaction.

The backup password is never persisted. Sensitive restored fields are encrypted again with the destination installation key before persistence.

## Accessibility boundary

- Shared loading and error states expose semantic live-region labels for assistive technologies.
- App-lock and reset states are scrollable so large system text does not overflow small screens.
- Navigation height adapts to larger text scales instead of disabling text scaling.
- Primary buttons and icon buttons maintain padded touch targets of at least 48 logical pixels.
- Decorative looping empty-state motion is disabled when the platform requests reduced animation; decorative graphics are excluded from the semantics tree.

These presentation rules do not alter transaction, budget, goal, recurring, or backup behavior.

## Android release boundary

PiggyAI explicitly uses `compileSdk = 36` and `targetSdk = 36` for Android 16 / the 2026 Google Play submission requirement. The project already uses Android Gradle Plugin 9.x, which is compatible with this target line.

Pull-request CI never receives the Android release keystore. It runs generation, formatting, strict analysis, tests, artifact-hygiene checks, and a debug APK build only.

After merge to `main`, CI reconstructs the upload keystore temporarily from GitHub Actions secrets, builds the release APK and Play AAB, verifies both signatures, rejects an APK whose certificate identifies as `Android Debug`, generates SHA-256 checksums, and uploads the files as a short-lived Actions artifact. Temporary signing material is deleted in an `always()` cleanup step.

`dist/` is ignored and CI fails if any file below it is tracked by Git. Release APK/AAB binaries therefore belong in GitHub Actions artifacts, not source control.

## Store privacy and submission boundary

- `settings/presentation/privacy_policy_screen.dart` exposes the current policy inside the app without requiring a network connection.
- `docs/store/privacy-policy.md` is the canonical public store-policy text. It must be published/linked from a stable public URL in Google Play Console and App Store Connect before submission.
- `docs/store/google-play-release.md` documents the SMS-based money-management permissions declaration, prominent-disclosure review-video flow, expected local-only Data safety posture, Play App Signing artifact flow, and remaining manual Play Console tasks.
- `docs/store/app-store-release.md` documents the iOS manual-entry behavior, App Privacy posture, Xcode/iOS SDK submission requirement, privacy-manifest audit, and remaining manual App Store Connect tasks.
- `docs/store/store-listing-copy.md` keeps Android SMS access visible as a core feature in Play listing/review copy and avoids claiming SMS access on iOS.
- Any future dependency or architecture change that introduces networking, analytics, remote crash reporting, advertising, remote AI, account/cloud sync, or another sensitive permission requires a fresh store privacy and permissions audit before release.
