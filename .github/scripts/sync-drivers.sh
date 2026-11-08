#!/usr/bin/env bash
# Adds modem drivers that upstream DOCSight registers, but the add-on's
# `modem_type` schema lacks, to docsight/config.yaml (before the trailing
# `generic` fallback).
#
# Usage: sync-drivers.sh <upstream-tag>
#
# Prints a markdown note for the release notes on stdout: what was added,
# or -- if the edit could not be applied cleanly and was reverted -- the
# warning from check-drivers.sh instead. Prints nothing if nothing is
# missing. Always exits 0. CONFIG overrides the config path (tests).
set -uo pipefail

tag="${1:?upstream tag}"
here="$(dirname "$0")"
config="${CONFIG:-docsight/config.yaml}"

missing="$("$here/check-drivers.sh" --list "$tag")"
[ -n "$missing" ] || exit 0

names="$(printf '%s\n' "$missing" | paste -sd'|' -)"
pretty="$(printf '%s\n' "$missing" | paste -sd, - | sed 's/,/, /g')"

backup="$(mktemp)"
trap 'rm -f "$backup"' EXIT
cp "$config" "$backup"

sed -i -E "/^  modem_type: \"list\(/ s/\|generic\)\"\$/|${names}|generic)\"/" "$config"

# The edited line must still be a plain list containing every new name.
ok=1
line="$(grep -E '^  modem_type: "list\(' "$config")"
printf '%s\n' "$line" | grep -qE '^  modem_type: "list\([a-z0-9_|]+\)"$' || ok=0
for n in $missing; do
  printf '%s\n' "$line" | grep -qE "[(|]${n}[|)]" || ok=0
done

if [ "$ok" = 1 ]; then
  echo "> **Added modem types to the \`modem_type\` option (new upstream drivers, added automatically):** ${pretty}"
else
  cp "$backup" "$config"
  echo "sync-drivers: could not edit the modem_type schema, reverted" >&2
  echo "> ⚠️ **New upstream modem drivers not yet selectable in \`modem_type\`:** ${pretty}"
fi
exit 0
