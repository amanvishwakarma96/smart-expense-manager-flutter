# App Store release guide

This document is the PiggyAI App Store Connect submission checklist for iOS.

## App identity and platform behavior

- Current iOS bundle identifier: `com.smartspend.app.smartExpenseManager`.
- Confirm this exact identifier is the intended long-term App Store identity before creating the first App Store Connect record; do not change bundle identity casually after distribution begins.
- PiggyAI on iOS uses manual transaction entry because iOS does not expose the device SMS inbox to PiggyAI.
- The app has no PiggyAI backend/account, remote AI, analytics, advertising, telemetry, or automatic cloud sync.
- Encrypted backup export is explicit and user initiated.

## Current Apple SDK submission requirement

As of the current release-preparation date, apps uploaded to App Store Connect must be built with **Xcode 26 or later** using the **iOS 26 SDK or later**.

This requirement cannot be validated by the Linux GitHub Actions job. Before App Store submission, build/archive on a Mac with the required Xcode/iOS SDK and run the normal Flutter/iOS release checks.

## App Privacy answers

Apple defines collection around data being transmitted off the device in a way that allows the developer or a third party to access it beyond servicing a real-time request. With PiggyAI's current local-only architecture, the expected App Store Connect answer is:

- **Do you or your third-party partners collect data from this app?** No.

This assumes the shipping iOS build remains free of analytics, advertising, remote crash reporting, telemetry, cloud sync, remote AI, or any SDK that transmits user/device data.

Re-audit all dependencies immediately before submission because App Store privacy responses must also cover third-party partner behavior.

## Privacy policy

App Store Connect requires a publicly accessible privacy-policy URL. Use the merged `docs/store/privacy-policy.md` as the canonical policy text and publish it at a stable public URL before submission.

PiggyAI also exposes the policy locally inside the app under **Settings → Privacy contract → Read privacy policy**.

## Privacy manifests and required-reason APIs

Apple requires valid privacy manifests for covered apps/SDKs and rejects submissions that use required-reason APIs without approved reasons.

Before each App Store archive:

1. Use Xcode's privacy report/archive inspection to review the app and included SDK privacy manifests.
2. Confirm any third-party SDK on Apple's required SDK list includes a valid signed privacy manifest where applicable.
3. If PiggyAI's own iOS code begins using a required-reason API directly, add the appropriate `PrivacyInfo.xcprivacy` entry with an Apple-approved reason that accurately matches the feature.
4. Do not add speculative privacy-manifest reasons for APIs PiggyAI does not use.
5. Keep App Store Connect privacy answers consistent with the final binary and its SDKs.

## Age rating

Complete the current App Store Connect age-rating questionnaire for the app. PiggyAI is a personal finance/expense-management tool and does not contain gambling, advertising, random chat, user-to-user messaging, or mature content in the current build.

## Review notes

Suggested review note:

> PiggyAI is an offline-first personal expense manager. The iOS build does not access SMS; transactions are entered manually. Financial data stays on the device and there is no app account, backend, cloud sync, advertising, analytics, telemetry, or remote AI. Backup export is encrypted and user initiated. The Privacy Policy is also available inside Settings.

## Release checklist

- Confirm `com.smartspend.app.smartExpenseManager` as the final bundle identifier before the first App Store record is created.
- Build with the currently required Xcode/iOS SDK.
- Run `dart format lib test`, `flutter analyze --fatal-infos`, and `flutter test` before archive.
- Run `flutter build ios --release` or archive from Xcode with production signing configured.
- Verify app icon, launch presentation, device orientations, and minimum deployment target on real supported devices.
- Inspect the archive privacy report and embedded privacy manifests.
- Enter the public privacy-policy URL.
- Complete App Privacy, age rating, export-compliance, content-rights, and availability questions.
- Add screenshots, promotional text/subtitle, description, keywords, support URL/email, and review notes.
- Upload through Xcode/Transporter and resolve all App Store Connect warnings before review.
