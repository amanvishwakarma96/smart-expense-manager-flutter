# Production readiness

Phase 12 hardens PiggyAI's existing offline-first product without adding a backend, remote AI, analytics, telemetry, advertising, or Android internet access.

## User-facing safety

- System reduce-motion preferences stop the looping decorative empty-state animation.
- App startup/lock loading states expose screen-reader-friendly progress labels.
- Large text can scroll through lock/reset states and receives extra bottom-navigation height.
- Interactive controls use padded touch targets.
- Restore no longer jumps directly from password entry to a generic replacement warning. PiggyAI first decrypts the backup in memory and shows its creation date, snapshot version, and counts for transactions, categories, merchant rules, recurring items, and savings goals.
- Backup inspection is read-only. The financial database is replaced only after the separate **Replace and restore** confirmation and the restore service's full validation.

## Release safety

- App metadata is aligned to `0.10.0+10` for this release line.
- Build outputs under `dist/` are never allowed in source control.
- Historical APK files that were accidentally tracked are removed from the current repository tip.
- Pull requests do not receive release-signing secrets.
- `main` builds produce a signed tester APK and Play Store AAB.
- CI verifies APK/AAB signatures, rejects the Android debug certificate, and publishes SHA-256 checksums alongside the artifacts.

## Privacy invariants

Production hardening preserves the existing privacy contract:

- no Android `INTERNET` permission;
- no HTTP client, cloud sync, backend, remote model, analytics, ads, or telemetry;
- sensitive persisted text remains encrypted with the installation-specific `SecureCipherService` pattern;
- encrypted backup passwords and signing credentials are never committed;
- no analysis or UX hardening path silently confirms, deletes, edits, or creates a financial record.
