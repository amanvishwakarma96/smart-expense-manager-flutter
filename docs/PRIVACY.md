# Privacy and security contract

## Guarantees implemented

- No backend or remote account.
- No cloud synchronization.
- No analytics, advertising, telemetry, or remote crash SDK.
- No Android `INTERNET` permission in main, debug, or profile manifests.
- Android cloud backup and device-transfer backup are disabled.
- Incoming SMS queue is encrypted with Android Keystore.
- Merchant, account-tail, original SMS, debt counterparty, and private debt-note text are encrypted before Isar persistence.
- Raw SMS content is never printed or included in notifications.
- Debt and loan reminders use generic notification text with no counterparty, amount, account, balance, category, note, or SMS content.
- Debt records, manual debt movements, and confirmed-transaction links are never created automatically; each requires an explicit user action.
- EMI/repayment plans contain local schedule metadata only. Their deterministic projections never create transactions, mark repayments paid, or mutate debt balances.
- Android SMS access is opt-in and limited to the core money-management feature.
- Before first-time SMS permission, PiggyAI displays a dedicated in-app disclosure explaining local access, background receipt, storage behavior, no off-device transmission, and the manual-entry alternative.
- The disclosure requires explicit **Agree & continue** consent; **Not now** does not trigger the Android permission prompt.
- Manual entry remains available without SMS permission.
- `FLAG_SECURE` prevents screenshots and recent-app previews on Android.
- Optional biometric or device-lock protection is available.
- Users can permanently delete local financial data, debt/loan ledgers, repayment plans, local reminders, and the installation key.
- A full local Privacy Policy is accessible from Settings without network access.

## Public store policy

The canonical store-facing policy text lives in `docs/store/privacy-policy.md`. Google Play and App Store submission guidance lives under `docs/store/` and must be re-audited whenever the app adds or changes a dependency, permission, networking behavior, analytics/diagnostics feature, or data-transfer path.

Debt/loan and repayment planning do not introduce a new collection or sharing path: the data stays on-device and leaves only when the user explicitly creates and shares a password-encrypted backup.

## Threat-model boundaries

PiggyAI protects against accidental cloud exposure, ordinary app-to-app access, backup leakage, screenshots, and casual file extraction. No mobile application can guarantee protection on a rooted, jailbroken, malware-compromised, or physically unlocked device. Users should keep their operating system and device lock up to date.
