#!/usr/bin/env bash
set -euo pipefail

apk_path="${1:-}"
if [[ -z "$apk_path" || ! -f "$apk_path" ]]; then
  echo "Usage: $0 <apk-path>" >&2
  exit 2
fi

android_home="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
if [[ -z "$android_home" ]]; then
  echo "ANDROID_HOME or ANDROID_SDK_ROOT must be set." >&2
  exit 2
fi

zipalign_path="$(find "$android_home/build-tools" -type f -name zipalign | sort -V | tail -n 1)"
if [[ -z "$zipalign_path" ]]; then
  echo "zipalign was not found in Android SDK Build-Tools." >&2
  exit 2
fi

objdump_path="$(find "$android_home/ndk" -type f -name llvm-objdump 2>/dev/null | sort -V | tail -n 1)"
if [[ -z "$objdump_path" ]]; then
  echo "llvm-objdump was not found in an installed Android NDK." >&2
  exit 2
fi

echo "Checking 16 KB APK zip alignment: $apk_path"
"$zipalign_path" -v -c -P 16 4 "$apk_path"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
unzip -q "$apk_path" 'lib/*/*.so' -d "$tmp_dir" || true

mapfile -t shared_libraries < <(
  find "$tmp_dir/lib" -type f \( -path '*/arm64-v8a/*.so' -o -path '*/x86_64/*.so' \) 2>/dev/null | sort
)

if [[ ${#shared_libraries[@]} -eq 0 ]]; then
  echo "No arm64-v8a or x86_64 shared libraries found; ELF alignment check is not required."
  exit 0
fi

failed=0
for library in "${shared_libraries[@]}"; do
  relative="${library#"$tmp_dir/"}"
  load_lines="$("$objdump_path" -p "$library" | grep '^    LOAD' || true)"
  if [[ -z "$load_lines" ]]; then
    echo "UNALIGNED $relative (no LOAD segments found)"
    failed=1
    continue
  fi

  library_failed=0
  while IFS= read -r line; do
    exponent="$(sed -n 's/.*align 2\*\*\([0-9][0-9]*\).*/\1/p' <<<"$line")"
    if [[ -z "$exponent" || "$exponent" -lt 14 ]]; then
      library_failed=1
      break
    fi
  done <<<"$load_lines"

  if [[ "$library_failed" -eq 1 ]]; then
    echo "UNALIGNED $relative"
    printf '%s\n' "$load_lines"
    failed=1
  else
    echo "ALIGNED   $relative"
  fi
done

if [[ "$failed" -ne 0 ]]; then
  echo "One or more native libraries are not 16 KB ELF-aligned." >&2
  exit 1
fi

echo "All checked native libraries and APK entries are 16 KB aligned."
