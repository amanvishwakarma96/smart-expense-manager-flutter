# Android release artifacts

CI release packaging writes signed APK/AAB files and verification reports into the temporary `dist/` directory. The directory is intentionally ignored by Git and must never be committed.

On trusted `main` or manual workflow runs, GitHub Actions uploads these files as the `PiggyAI-Android-Release-<run>` artifact:

- signed APK for direct installation/testing
- signed AAB for Google Play
- SHA-256 checksums
- APK signature verification output
- AAB signature verification output

The source-diff cleanliness check runs before build artifact packaging so generated release files cannot cause a false dirty-tree failure.
