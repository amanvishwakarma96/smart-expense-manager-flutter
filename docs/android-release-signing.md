# Android release signing

PiggyAI release builds must use the permanent upload/release key. The private
keystore and passwords must never be committed to this repository.

## GitHub Actions secrets

The repository uses these encrypted Actions secrets:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

Pull-request jobs never receive or use the release signing material. Signed
release artifacts are produced only on trusted non-PR runs such as a push to
`main` or a manual workflow run.

The workflow decodes the Base64 keystore into a temporary runner file, builds a
signed APK and signed Android App Bundle, verifies the artifacts, uploads them,
and removes the temporary keystore before the job finishes.

## Local signing

Create `android/key.properties` locally. This file is ignored by Git.

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=piggyai-upload
storeFile=/absolute/path/to/piggyai-upload-key.jks
```

Then build:

```bash
flutter build apk --release
flutter build appbundle --release
```

Outputs:

- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

A release build fails instead of silently falling back to the Android debug key
when signing is not configured.

## Key handling

- Keep the original `.jks` outside the repository.
- Keep at least one secure backup of the keystore and its credentials.
- Do not rotate or replace the key casually; Android app updates rely on a
  consistent signing identity.
- Use the AAB for Google Play distribution and the APK for controlled direct
  testing.
