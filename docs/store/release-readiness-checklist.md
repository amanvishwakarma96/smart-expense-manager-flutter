# PiggyAI store release readiness checklist

Use this checklist after Phase 13 is merged and before submitting a production build to either store.

## Repository gates

- [ ] `dart format lib test` passes with no uncommitted formatting changes.
- [ ] `flutter analyze --fatal-infos` passes.
- [ ] `flutter test` passes.
- [ ] Android API level remains `compileSdk = 36` and `targetSdk = 36`.
- [ ] Android production manifests contain no `INTERNET` permission.
- [ ] Android debug APK passes `tool/check_android_16kb.sh` on pull requests.
- [ ] Signed Android release APK passes the same 16 KB alignment check on `main`.
- [ ] Signed release APK is not signed by the Android Debug certificate.
- [ ] Signed release AAB verifies successfully and stays outside Git source control.
- [ ] App version is incremented before every store upload.

## Identity decisions before first store record

- [ ] Confirm Android application ID `com.smartspend.app` as the permanent Google Play identity.
- [ ] Confirm iOS bundle identifier `com.smartspend.app.smartExpenseManager` as the permanent App Store identity.
- [ ] Confirm final public app name **PiggyAI**.
- [ ] Confirm developer/publisher display name used in both stores.

Do not change an application/bundle identifier casually after distribution begins. Treat an identity change as a separate migration/release decision.

## Public support and privacy material

- [ ] Publish `docs/store/privacy-policy.md` at a stable public HTTPS URL.
- [ ] Enter that URL in Google Play Console.
- [ ] Enter that URL in App Store Connect.
- [ ] Keep the in-app Settings → Privacy contract → Read privacy policy screen aligned with the public policy.
- [ ] Provide a real support email address monitored by the publisher.
- [ ] Provide a stable support/project website or repository URL where each store asks for one.

## Google Play Console

- [ ] Upload the signed versioned `.aab` from the protected `main` CI artifact.
- [ ] Confirm Play App Signing.
- [ ] Complete the SMS/Call Log Permissions Declaration for the SMS-based money-management use case if Play surfaces the form.
- [ ] Provide the permissions-review video showing both decline and consent flows plus the core SMS review feature.
- [ ] Complete Data safety based on the shipping binary and all dependencies.
- [ ] Complete the mandatory Financial features declaration and accurately describe PiggyAI as local expense/budget tracking; do not select banking, lending, payments, trading, insurance, or advice features that the app does not provide.
- [ ] Complete Ads, App access, Target audience, Content rating, and other App content declarations.
- [ ] Confirm the uploaded AAB reports 16 KB page alignment with the current Play/bundletool release audit.
- [ ] Add final phone/tablet screenshots as applicable, 512×512 Play icon, 1024×500 feature graphic, descriptions, category, and contact details.
- [ ] Run Internal testing first, then the appropriate closed/open/production track.

## iOS / App Store Connect

- [ ] Build/archive on a Mac using the currently required Xcode and iOS SDK versions.
- [ ] Confirm production signing/provisioning for the final bundle identifier.
- [ ] Inspect the Xcode archive privacy report and embedded privacy manifests.
- [ ] Re-audit third-party SDK privacy behavior before answering App Privacy.
- [ ] Complete App Privacy, age rating, export compliance, content rights, and availability questions.
- [ ] Add final App Store icon/screenshots, subtitle, description, keywords, support URL/email, and review notes.
- [ ] Upload with Xcode/Transporter and resolve every App Store Connect warning before review.
- [ ] Test the distributed build through TestFlight before production submission.

## Store assets still require a visual review

Repository/CI compliance does not prove that the current launcher icon, screenshots, feature graphic, or launch presentation are final brand assets. Before public release, review them on real devices and replace any default/placeholder-looking asset through a separate design change. Do not hold sensitive financial information in store screenshots.

## Release evidence to retain

For each production candidate, keep the CI run number, commit SHA, signed artifact checksum, APK/AAB signature reports, store-upload version/build number, permission-review video version, privacy-policy revision date, and the final console declarations used for that binary.
