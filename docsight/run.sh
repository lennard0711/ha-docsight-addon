#!/usr/bin/env bash
set -e

CONFIG=/data/options.json

# Only the bootstrap options below are exported. DOCSight's ConfigManager
# (app/config.py) resolves each of these keys as: env var > config.json >
# default, checked on every read -- not just at container start. That means
# whatever is set here always wins over the same setting in DOCSight's own
# /settings UI. Everything DOCSight offers that is NOT in this list (theme,
# language, notifications, Smart Capture, ISP name, timezone, ...) has no
# env var equivalent at all and is safe to leave to the UI. See DOCS.md.
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

# The Dockerfile symlinks /backup -> /data/backups so DOCSight's scheduled
# backup feature persists in /data. But `os.makedirs("/backup", exist_ok=True)`
# fails on a *dangling* symlink: mkdir() doesn't follow a symlink's final
# path component, and exist_ok only swallows that via a real, resolvable
# directory at the target. So the directory has to exist before DOCSight's
# own bootstrap ever runs -- create and own it now, as root, rather than
# relying on entrypoint.sh's /data chown (which is skipped on restarts once
# /data's own top-level ownership already looks correct, which would leave
# a freshly created subdirectory root-owned and unwritable by appuser).
mkdir -p /data/backups
chown 1000:1000 /data/backups 2>/dev/null || true

# Hand off to the upstream image's own entrypoint (verified via
# `docker inspect`): it fixes /data ownership as root, then execs
# `gosu appuser "$@"`. "$@" here is the CMD inherited from the upstream
# image (python -m app.main), since this Dockerfile does not override CMD.
exec /entrypoint.sh "$@"
