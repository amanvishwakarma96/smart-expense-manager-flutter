# Privacy and security contract

## Guarantees implemented

- No backend or remote account.
- No cloud synchronization.
- No analytics, advertising, telemetry, or remote crash SDK.
- No Android `INTERNET` permission in main, debug, or profile manifests.
- Android cloud backup and device-transfer backup are disabled.
- Incoming SMS queue is encrypted with Android Keystore.
- Merchant, account-tail, and original SMS text are encrypted before Isar persistence.
- Raw SMS content is never printed or included in notifications.
- SMS access is opt-in; manual entry remains available without permission.
- `FLAG_SECURE` prevents screenshots and recent-app previews on Android.
- Optional biometric or device-lock protection is available.
- Users can permanently delete local financial data and the installation key.

## Threat-model boundaries

PiggyAI protects against accidental cloud exposure, ordinary app-to-app access, backup leakage, screenshots, and casual file extraction. No mobile application can guarantee protection on a rooted, jailbroken, malware-compromised, or physically unlocked device. Users should keep their operating system and device lock up to date.
