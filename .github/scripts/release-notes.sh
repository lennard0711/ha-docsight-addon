#!/usr/bin/env bash
# Prints the CHANGELOG/release-notes body for an automated upstream bump.
#
# Usage: release-notes.sh <addon> <upstream-tag>
#
# Fetches the upstream project's GitHub release notes (needs `gh` and
# GH_TOKEN) and reformats them to sit under a "## <version>" CHANGELOG
# heading. Never fails: on any problem it prints the generic one-liner
# instead, so notes can never block a release.
set -uo pipefail

addon="${1:?addon}"
tag="${2:?upstream tag}"

case "$addon" in
  docsight)          repo="itsDNNS/docsight" ;;
  speedtest-tracker) repo="linuxserver/docker-speedtest-tracker" ;;
  *)                 repo="" ;;
esac

fallback() {
  printf '%s\n' "- Update to upstream \`${tag}\` (automated release)."
  exit 0
}

[ -n "$repo" ] || fallback

json="$(gh release view "$tag" --repo "$repo" --json body,url 2>/dev/null)" || fallback
body="$(printf '%s' "$json" | jq -r '.body // ""' | tr -d '\r')"
url="$(printf '%s' "$json" | jq -r '.url // ""')"

# Nothing but whitespace -> not useful.
[ -n "$(printf '%s' "$body" | tr -d '[:space:]')" ] || fallback

max=6000
truncated=""
if [ "${#body}" -gt "$max" ]; then
  body="$(printf '%s' "${body:0:$max}" | sed '$d')"
  truncated=1
fi

# - Demote headings by two levels so they nest under "## <version>".
# - Qualify bare #123 references with the upstream repo, otherwise they
#   would point at (or be read as) this repository's issues.
printf '%s\n' "$body" \
  | sed -E 's/^(#+)([[:space:]])/\1##\2/' \
  | sed -E "s@(^|[^[:alnum:]_/#&])#([0-9]+)@\1${repo}#\2@g"

echo
if [ -n "$truncated" ]; then
  echo "_Notes truncated._"
fi
if [ -n "$url" ]; then
  echo "[Upstream release notes](${url})"
fi
exit 0
