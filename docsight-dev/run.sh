#!/usr/bin/env bash
set -e
CONFIG=/data/options.json
export MODEM_TYPE=$(jq -r '.modem_type' "$CONFIG")
export MODEM_URL=$(jq -r '.modem_url' "$CONFIG")
export MODEM_USER=$(jq -r '.modem_user' "$CONFIG")
export MODEM_PASSWORD=$(jq -r '.modem_password' "$CONFIG")
export POLL_INTERVAL=$(jq -r '.poll_interval' "$CONFIG")
export LOG_LEVEL=$(jq -r '.log_level' "$CONFIG")
export MQTT_HOST=$(jq -r '.mqtt_host' "$CONFIG")
export MQTT_PORT=$(jq -r '.mqtt_port' "$CONFIG")
export MQTT_USER=$(jq -r '.mqtt_user' "$CONFIG")
export MQTT_PASSWORD=$(jq -r '.mqtt_password' "$CONFIG")
export ADMIN_PASSWORD=$(jq -r '.admin_password' "$CONFIG")
export DEMO_MODE=$(jq -r '.demo_mode' "$CONFIG")

mkdir -p /data/backups
chown appuser:appuser /data/backups 2>/dev/null || true

# Dev/ingress-test only: resolve this add-on's own Ingress mount path from
# the Supervisor API and hand it to DOCSight's new BASE_PATH support
# (see itsDNNS/docsight#781), matching the wrapper contract the upstream
# maintainer described. Falls back to root mode if ingress isn't enabled
# on this install or the lookup fails, so it still works either way.
if [ -n "$SUPERVISOR_TOKEN" ]; then
  info="$(curl -fsS -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/addons/self/info 2>/dev/null)" \
    || info="$(curl -fsS -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/apps/self/info 2>/dev/null)" \
    || info=""
  entry="$(printf '%s' "$info" | jq -r '.data.ingress_entry // empty' 2>/dev/null)"
  if [ -n "$entry" ]; then
    export BASE_PATH="$entry"
    echo "[docsight-dev] Resolved Ingress mount from Supervisor: BASE_PATH=$BASE_PATH"
  else
    echo "[docsight-dev] No ingress_entry from Supervisor -- starting in root mode. Raw response: $info"
  fi
else
  echo "[docsight-dev] No SUPERVISOR_TOKEN present -- starting in root mode"
fi

exec /entrypoint.sh "$@"
