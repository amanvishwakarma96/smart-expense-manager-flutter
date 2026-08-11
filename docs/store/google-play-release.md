# Google Play release guide

This document is the PiggyAI Play Console submission checklist for the current offline-first Android build.

## App identity

- App name: **PiggyAI**
- Current Android application ID: `com.smartspend.app`
- Distribution artifact: signed Android App Bundle (`.aab`) from the protected `main` GitHub Actions workflow.
- Play App Signing should remain enabled for production distribution.

> The application ID is effectively permanent after the first Play Console app is created/uploaded. Confirm this ID before the first public Play release. Do not change it casually after users have installed signed builds because Android treats a different application ID as a different app.

## Target API requirement

PiggyAI explicitly compiles against and targets Android 16 / API level 36 for the 2026 Google Play submission requirement.

Repository guard:

- `android/app/build.gradle.kts` contains `compileSdk = 36` and `targetSdk = 36`.
- Phase 13 contract tests fail if these values regress.

## 16 KB memory page-size compatibility

PiggyAI includes native shared libraries through Flutter and local database dependencies, so 16 KB compatibility must be verified rather than assumed.

The repository includes `tool/check_android_16kb.sh`, which performs both checks recommended for APK validation:

- `zipalign -c -P 16 -v 4` verifies APK/native-library zip alignment; and
- Android NDK `llvm-objdump` verifies every `arm64-v8a` and `x86_64` shared library has ELF LOAD-segment alignment of at least `2**14` (16 KB).

CI runs this check against every pull-request debug APK and against the signed release APK on `main`. A failing native library blocks the build so its dependency can be upgraded before release.

Google Play requires apps targeting Android 15 / API 35 and higher to support 16 KB page-size devices. Current Android guidance says Play will block non-compliant app updates starting 1 February 2027, so this compatibility check remains a permanent release gate rather than a one-time migration.

For the App Bundle, also inspect the final `.aab` with the current Android `bundletool` during the Play release audit and confirm its bundle configuration requests `PAGE_ALIGNMENT_16K`. AGP 9.x handles modern 16 KB packaging, but the actual signed release binaries remain the source of truth.

## Restricted SMS permissions

PiggyAI requests only the SMS permissions required by its core money-management feature:

- `READ_SMS` — user-triggered scan of recent transaction alerts in the SMS inbox.
- `RECEIVE_SMS` — detection of new bank/payment transaction alerts after the user has enabled the feature.

PiggyAI does **not** request `SEND_SMS`, `WRITE_SMS`, or Call Log permissions.

### Play Console declaration use case

Choose/describe the permitted use corresponding to **SMS-based money management** / budget and expense tracking.

Suggested declaration summary:

> PiggyAI is an offline-first personal expense manager whose core Android feature detects bank and payment transaction alerts from SMS. `READ_SMS` is used to scan recent financial alerts when the user requests a scan. `RECEIVE_SMS` is used to detect new financial alerts after the user enables SMS detection. Parsing occurs entirely on-device. Matching alerts become pending transactions and require user confirmation before they affect financial records. Unmatched SMS messages are not stored. SMS text and financial data are not transmitted to the developer, a backend, analytics, advertisers, or third parties. Manual entry remains available when SMS access is declined.

### Prominent disclosure flow

Before the Android runtime SMS permission request, PiggyAI displays a dedicated in-app disclosure that explains:

1. what data is accessed — SMS messages containing bank/payment alerts;
2. why it is accessed — local expense/transaction detection;
3. background behavior — new alerts may be detected after permission is enabled, including when the app is not open;
4. storage behavior — matching alerts become pending review items and unmatched messages are not stored;
5. sharing behavior — SMS and financial data are not sent to servers, analytics, advertisers, or third parties; and
6. choice — manual entry remains available without SMS permission.

The dialog provides explicit **Agree & continue** and **Not now** choices. The system SMS permission request is triggered only after affirmative consent.

### Permissions declaration review video

Record a short unedited device video that shows:

1. opening PiggyAI;
2. navigating to **Enable SMS detection** during onboarding or **Settings → On-device detection → Scan bank SMS**;
3. the entire PiggyAI SMS disclosure text;
4. tapping **Not now** and showing that no system SMS permission prompt appears and manual entry remains usable;
5. opening the flow again;
6. tapping **Agree & continue**;
7. the Android SMS permission prompt;
8. granting permission; and
9. a bank/payment SMS being processed locally into Pending Review, followed by explicit user confirmation/removal.

Do not include real account numbers or sensitive live financial details in the review video; use a controlled test device/test message where possible.

## Data safety section

PiggyAI's current architecture does not transmit app user data off-device to the developer or third parties. Under Google Play's Data safety definition of collection, the expected answers are therefore:

- **Does your app collect or share any of the required user data types?** No, based on the current build and dependencies.
- **Data shared with third parties:** None by PiggyAI.
- **Advertising/analytics:** None.
- **Account creation:** None.
- **Data deletion:** Local data can be deleted from Settings; no server-side account exists.

Important distinction: PiggyAI **accesses and processes** SMS/financial information locally, but does not transmit it off-device. The public privacy policy must still disclose this local access and the SMS permission use even though it is not reported as off-device collection.

Re-audit the Data safety answers whenever a dependency or architecture change could introduce networking, analytics, crash reporting, advertising, remote AI, or any other off-device transfer.

## Privacy policy

Use the public, merged repository copy of `docs/store/privacy-policy.md` as the source text for the store privacy-policy page. A stable public web URL should be entered in Play Console before submission. Prefer a permanent project/site URL rather than a temporary branch URL.

The same core policy is available inside PiggyAI from **Settings → Privacy contract → Read privacy policy**.

## Store listing copy

The store description must make SMS-based money management a visible core Android feature rather than a hidden secondary feature. Use the prepared copy in `docs/store/store-listing-copy.md`.

## Release artifact

After merging a release change to `main`:

1. Wait for Flutter CI to pass, including signed APK 16 KB alignment verification.
2. Download the `PiggyAI-Android-Release-<run>` artifact.
3. Use the versioned `PiggyAI-<version>-play-<run>-<sha>.aab` for Play Console.
4. Keep `SHA256SUMS.txt` and the signature reports with the release record.
5. Verify the final AAB reports `PAGE_ALIGNMENT_16K` with the current `bundletool` during release review.
6. Never upload a debug-signed APK/AAB or commit release binaries to Git.

## Manual Play Console actions that cannot be completed from this repository

- Create/select the Play Console app and confirm the application ID.
- Enable/confirm Play App Signing.
- Upload the signed AAB.
- Complete the SMS/Call Log Permissions Declaration Form if surfaced.
- Upload/provide the permissions review video.
- Enter the Data safety answers.
- Enter the privacy-policy URL.
- Complete content rating, target audience, app access, ads declaration, financial-features declarations if Play Console requests them, and any country-specific forms.
- Add screenshots, feature graphic, app icon, support email/site, and final store copy.
- Confirm the final AAB's 16 KB page-alignment status in the release audit.
- Submit the chosen testing/production track for review.
