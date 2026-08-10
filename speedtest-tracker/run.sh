#!/usr/bin/env bash
set -e

# The add-on's persistent data volume is mounted at /config (see
# config.yaml's map entry), not the usual /data -- Supervisor still drops
# options.json into the same physical directory either way.
CONFIG=/config/options.json
KEY_FILE=/config/.app_key

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
export APP_KEY=$(cat "$KEY_FILE")

export APP_URL=$(jq -r '.app_url' "$CONFIG")
export TZ=$(jq -r '.timezone' "$CONFIG")
export DISPLAY_TIMEZONE=$(jq -r '.timezone' "$CONFIG")
export ADMIN_NAME=$(jq -r '.admin_name' "$CONFIG")
export ADMIN_EMAIL=$(jq -r '.admin_email' "$CONFIG")
export ADMIN_PASSWORD=$(jq -r '.admin_password' "$CONFIG")
export SPEEDTEST_SCHEDULE=$(jq -r '.speedtest_schedule' "$CONFIG")
export SPEEDTEST_SERVERS=$(jq -r '.speedtest_servers' "$CONFIG")
export DB_CONNECTION=sqlite

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
