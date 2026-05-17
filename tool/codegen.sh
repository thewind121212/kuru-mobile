#!/usr/bin/env bash
# Regenerate Dart API clients from the BE's openapi specs.
#
# Run after any openapi spec change in ../gen-barcode/openapi/.
# Generated output is committed to git (see spec §9.1).
#
# Usage:
#   ./tool/codegen.sh           # regenerate all configured modules
#   ./tool/codegen.sh category  # regenerate only one module

set -euo pipefail

# Resolve a usable `dart` binary.
# Priority: $FLUTTER_ROOT/bin/dart → ~/flutter/bin/dart → first `dart` on PATH.
# Fails loudly if none work, instead of producing a cryptic "No such file"
# from the first `$DART` call deep in the script.
if [ -n "${FLUTTER_ROOT:-}" ] && [ -x "${FLUTTER_ROOT}/bin/dart" ]; then
  DART="${FLUTTER_ROOT}/bin/dart"
elif [ -x "${HOME}/flutter/bin/dart" ]; then
  DART="${HOME}/flutter/bin/dart"
elif command -v dart >/dev/null 2>&1; then
  DART="$(command -v dart)"
else
  echo "✗ codegen.sh: cannot find a 'dart' executable." >&2
  echo "  Set FLUTTER_ROOT, install Flutter at ~/flutter, or put dart on PATH." >&2
  exit 1
fi
GEN="run openapi_generator_cli:main"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Map module -> spec path. Add new modules here.
# Override by placing a patched spec at tool/openapi-patches/<module>.openapi.json
spec_for() {
  local module="$1"
  case "$module" in
    category) echo "../gen-barcode/openapi/category.openapi.json" ;;
    *) echo "" ;;
  esac
}

ALL_MODULES="category"

generate() {
  local module="$1"
  local input
  input="$(spec_for "$module")"
  local patched="tool/openapi-patches/${module}.openapi.json"

  if [ -f "$patched" ]; then
    input="$patched"
    echo "▶ ${module}: using patched spec at $patched"
  elif [ -z "$input" ]; then
    echo "✗ ${module}: no spec source configured" >&2
    return 1
  else
    echo "▶ ${module}: using upstream spec at $input"
  fi

  rm -rf "lib/api/${module}"
  $DART $GEN generate \
    -i "$input" \
    -g dart-dio \
    -o "lib/api/${module}" \
    --additional-properties=pubName=kuru_${module}_api,pubAuthor=kuru,pubVersion=0.4.0

  # dart-dio output uses built_value, which requires a build_runner pass
  # inside the sub-package to generate .g.dart serializer files.
  echo "▶ ${module}: running build_runner to generate .g.dart files"
  (cd "lib/api/${module}" && $DART pub get --no-example && $DART run build_runner build)
}

if [ $# -gt 0 ]; then
  generate "$1"
else
  for module in $ALL_MODULES; do
    generate "$module"
  done
fi

echo "✓ codegen complete"
