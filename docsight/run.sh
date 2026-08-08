#!/usr/bin/env bash
set -e

CONFIG=/data/options.json

# Only these bootstrap options are exported. DOCSight resolves each key as
# env var > config.json > default on every read, so anything set here
# always overrides the same setting in DOCSight's own /settings UI.
# Everything else DOCSight offers (theme, language, notifications, Smart
# Capture, ISP name, timezone, ...) has no env var equivalent and is safe
# to configure there instead. See DOCS.md.
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

# /data/backups needs to exist and be owned by appuser before DOCSight
# starts, so its scheduled backups (symlinked to /backup in the Dockerfile)
# can be written on the very first run.
mkdir -p /data/backups
chown appuser:appuser /data/backups 2>/dev/null || true

# Hand off to DOCSight's own entrypoint, which drops root privileges via
# gosu before starting the app.
exec /entrypoint.sh "$@"
