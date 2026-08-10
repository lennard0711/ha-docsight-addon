#!/usr/bin/env bash
set -euo pipefail

CONFIG=/data/options.json

# jq's `//` operator would also replace a legitimate `false`, so map only
# null to "", and stringify numbers/booleans for the environment.
opt() {
  jq -r --arg k "$1" '.[$k] | if . == null then "" else tostring end' "$CONFIG"
}

MODEM_TYPE="$(opt modem_type)"
MODEM_URL="$(opt modem_url)"
MODEM_USER="$(opt modem_user)"
MODEM_PASSWORD="$(opt modem_password)"
POLL_INTERVAL="$(opt poll_interval)"
LOG_LEVEL="$(opt log_level)"
MQTT_HOST="$(opt mqtt_host)"
MQTT_PORT="$(opt mqtt_port)"
MQTT_USER="$(opt mqtt_user)"
MQTT_PASSWORD="$(opt mqtt_password)"
ADMIN_PASSWORD="$(opt admin_password)"
DEMO_MODE="$(opt demo_mode)"

# Zero-config MQTT: with the default broker host and no credentials set,
# fetch connection details from the Supervisor's MQTT service (provided by
# e.g. the Mosquitto add-on). Explicitly configured values always win, and
# a blank mqtt_host still disables MQTT entirely.
if [ "$MQTT_HOST" = "core-mosquitto" ] && [ -z "$MQTT_USER" ] && [ -z "$MQTT_PASSWORD" ] \
    && [ -n "${SUPERVISOR_TOKEN:-}" ]; then
  if svc="$(curl -fsS -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/services/mqtt 2>/dev/null)"; then
    MQTT_HOST="$(printf '%s' "$svc" | jq -r '.data.host // empty')"
    MQTT_PORT="$(printf '%s' "$svc" | jq -r '.data.port // empty')"
    MQTT_USER="$(printf '%s' "$svc" | jq -r '.data.username // empty')"
    MQTT_PASSWORD="$(printf '%s' "$svc" | jq -r '.data.password // empty')"
    echo "[docsight] MQTT auto-configured from the Supervisor MQTT service (host: ${MQTT_HOST})"
  else
    echo "[docsight] No Supervisor MQTT service available -- using configured MQTT options as-is"
  fi
fi

export MODEM_TYPE MODEM_URL MODEM_USER MODEM_PASSWORD POLL_INTERVAL LOG_LEVEL \
  MQTT_HOST MQTT_PORT MQTT_USER MQTT_PASSWORD ADMIN_PASSWORD DEMO_MODE

mkdir -p /data/backups
chown appuser:appuser /data/backups 2>/dev/null || true

exec /entrypoint.sh "$@"
