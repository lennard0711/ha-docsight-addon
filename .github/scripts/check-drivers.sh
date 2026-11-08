#!/usr/bin/env bash
# Warns about modem drivers upstream DOCSight registers that are missing
# from the add-on's hardcoded `modem_type` schema in docsight/config.yaml.
#
# Usage: check-drivers.sh <upstream-tag>
#
# Prints one warning line on stdout if there is a mismatch, nothing
# otherwise. Always exits 0: if upstream's file can't be fetched or parsed
# (sanity check below), it only logs to stderr -- a parser hiccup must not
# block a release. DRIVERS_FILE overrides the download (used for tests).
set -uo pipefail

tag="${1:?upstream tag}"
config="${CONFIG:-docsight/config.yaml}"

src="$(mktemp)"
trap 'rm -f "$src"' EXIT

if [ -n "${DRIVERS_FILE:-}" ]; then
  cp "$DRIVERS_FILE" "$src"
else
  curl -fsS --max-time 20 \
    "https://raw.githubusercontent.com/itsDNNS/docsight/${tag}/app/drivers/__init__.py" \
    -o "$src" 2>/dev/null || { echo "check-drivers: could not fetch drivers file for ${tag}" >&2; exit 0; }
fi

schema="$(grep -oP 'modem_type:\s*"list\(\K[^)]+' "$config" | tr '|' '\n')"
[ -n "$schema" ] || { echo "check-drivers: no modem_type schema found in ${config}" >&2; exit 0; }

# Quoted first argument of register-style calls.
upstream="$(grep -E 'register[a-z_]*\(' "$src" \
  | grep -oP 'register[a-z_]*\(\s*["'"'"']\K[a-z0-9_]+' | sort -u)"

# Sanity check: a working parse must find at least two names we already
# know. Otherwise the file format probably changed -- say nothing.
known=$(printf '%s\n' "$upstream" | grep -Fxcf <(printf '%s\n' "$schema"))
if [ "$known" -lt 2 ]; then
  echo "check-drivers: could not recognise driver registrations upstream, skipping check" >&2
  exit 0
fi

missing="$(printf '%s\n' "$upstream" | grep -vFxf <(printf '%s\n' "$schema") | paste -sd, - | sed 's/,/, /g')"
if [ -n "$missing" ]; then
  echo "> ⚠️ **New upstream modem drivers not yet selectable in \`modem_type\`:** ${missing}"
fi
exit 0
