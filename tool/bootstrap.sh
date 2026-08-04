#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is not installed or is not available on PATH." >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "rsync is required to generate missing platform files." >&2
  exit 1
fi

if [[ ! -f android/settings.gradle.kts || ! -f ios/Runner.xcodeproj/project.pbxproj ]]; then
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TEMP_DIR"' EXIT

  flutter create \
    --org com.smartspend.app \
    --project-name smart_expense_manager \
    --template app \
    --platforms android,ios \
    "$TEMP_DIR/generated"

  mkdir -p android ios
  rsync -a --ignore-existing "$TEMP_DIR/generated/android/" android/
  rsync -a --ignore-existing "$TEMP_DIR/generated/ios/" ios/
  cp "$TEMP_DIR/generated/.metadata" .metadata

  find android/app/src/main/kotlin \
    -path "*/smart_expense_manager/MainActivity.kt" \
    -delete || true
fi

flutter pub get
dart run build_runner build
dart format lib test
flutter analyze --fatal-infos
flutter test

echo "PiggyAI bootstrap and validation completed successfully."
