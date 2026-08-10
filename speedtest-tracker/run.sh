#!/usr/bin/env bash
set -euo pipefail

# The add-on's persistent data volume is mounted at /config (see
# config.yaml's map entry), not the usual /data -- Supervisor still drops
# options.json into the same physical directory either way.
CONFIG=/config/options.json
KEY_FILE=/config/.app_key

# jq's `//` operator would also replace a legitimate `false`, so map only
# null to "", and stringify numbers/booleans for the environment.
opt() {
  jq -r --arg k "$1" '.[$k] | if . == null then "" else tostring end' "$CONFIG"
}

# APP_KEY encrypts stored data and has no default; Speedtest Tracker halts
# on startup if it's missing. Generate one on first run and persist it so
# it survives restarts and image updates -- losing it would make existing
# encrypted data unreadable.
FIRST_BOOT=false
if [ ! -f "$KEY_FILE" ]; then
  FIRST_BOOT=true
  echo "base64:$(openssl rand -base64 32)" > "$KEY_FILE"
  chmod 600 "$KEY_FILE"
fi
APP_KEY="$(cat "$KEY_FILE")"

APP_URL="$(opt app_url)"
TZ="$(opt timezone)"
DISPLAY_TIMEZONE="$TZ"
ADMIN_NAME="$(opt admin_name)"
ADMIN_EMAIL="$(opt admin_email)"
ADMIN_PASSWORD="$(opt admin_password)"
SPEEDTEST_SCHEDULE="$(opt speedtest_schedule)"
SPEEDTEST_SERVERS="$(opt speedtest_servers)"
DB_CONNECTION=sqlite

export APP_KEY APP_URL TZ DISPLAY_TIMEZONE ADMIN_NAME ADMIN_EMAIL ADMIN_PASSWORD \
  SPEEDTEST_SCHEDULE SPEEDTEST_SERVERS DB_CONNECTION

# ADMIN_* only take effect once, in the initial database migration that
# creates the admin user -- changing them later has no effect. If this is
# a fresh install with no password set, Speedtest Tracker falls back to
# its own built-in default ("password").
if [ "$FIRST_BOOT" = true ] && [ -z "$ADMIN_PASSWORD" ]; then
  echo "WARNING: admin_password is not set. Speedtest Tracker will create" >&2
  echo "the initial admin account with its built-in default password" >&2
  echo "('password'). Set admin_password in the add-on configuration" >&2
  echo "before the first start to avoid this." >&2
fi

exec /init
