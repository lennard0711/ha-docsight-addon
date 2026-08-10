# Changelog

## UNRELEASED (will ship as <new-upstream-tag>-addon.2 once upstream tags the ingress fix)

- Home Assistant sidebar support via Ingress: new `web_ui` option,
  `ingress` (default) serves the UI through the sidebar, `direct` keeps
  the previous port-8765 behavior. The modes are mutually exclusive --
  DOCSight renders URLs for exactly one mount point. Requires the
  upstream release containing itsDNNS/docsight#783.

## v2026-08-07.1-addon.7

- Zero-config MQTT: with the default broker host and no credentials set,
  connection details are now fetched automatically from the Mosquitto
  add-on via the Supervisor's MQTT service. Manually configured values
  still win, and a blank `mqtt_host` still disables MQTT.
- Home Assistant backups now stop the add-on briefly (`backup: cold`) so
  the SQLite history database is captured in a consistent state.
- Hardened the startup script (strict shell mode, safer option parsing).

## v2026-08-07.1-addon.6

- Housekeeping release, no functional changes to DOCSight itself:
  `run.sh` now chowns `/data/backups` by user name (`appuser`) instead of
  hardcoded UID 1000, stale comment in `config.yaml` about manually setting
  the backup path removed (the symlink handles it since addon.5), MQTT
  disable edge case documented in DOCS.md, CI now also tags images as
  `latest`.

## v2026-08-07.1-addon.5

- Symlink `/backup` to `/data/backups` in the Dockerfile, so DOCSight's
  scheduled/automatic backup feature (which isn't env-configurable and
  defaults to writing to `/backup`) persists in the add-on's own `/data`
  volume without needing anything changed in DOCSight's `/settings`. The
  manual "download backup" button is unaffected -- it streams straight to
  the browser and never touches `/backup`.
- Smoke test now exercises this end-to-end: triggers a scheduled backup via
  the API and checks the file actually lands on the mounted `/data` volume.
  (It caught a real bug during development: `os.makedirs("/backup", ...)`
  fails on a dangling symlink on the very first run, before `/data/backups`
  exists yet. Fixed by having `run.sh` create and `chown` it upfront.)

## v2026-08-07.1-addon.4

- Revert the `/backup` mapping added in addon.3. Checked Supervisor's
  source: `map: - type: backup` bind-mounts the single, shared Home
  Assistant system-backup folder used for real `.tar` snapshots, not an
  isolated per-add-on location -- not the right place for an unrelated
  app's own export files. `/data` is the actually-intended mechanism
  (Supervisor already includes it automatically in every HA backup); see
  DOCS.md for pointing DOCSight's own backup path at `/data/backups`.

## v2026-08-07.1-addon.3

- Map DOCSight's built-in backup/export path (`/backup`) to Home
  Assistant's real backup folder, so exports created through DOCSight's
  own UI actually persist instead of being lost on the next image update.
- Add `watchdog` pointed at DOCSight's `/health` endpoint, so Supervisor
  restarts the add-on if it crashes or hangs.
- Add `webui` so the add-on's info page has a direct "Open Web UI" button.

## v2026-08-07.1-addon.2

- Fix container failing to start with only gosu's usage help printed to
  the log. Declaring a new `ENTRYPOINT` in the Dockerfile silently reset
  the `CMD` inherited from the upstream image to empty, so `run.sh` had
  nothing to hand off to `/entrypoint.sh`. `CMD` is now re-declared
  explicitly in the Dockerfile.

## v2026-08-07.1-addon.1

- Initial release. Wraps upstream DOCSight `v2026-08-07.1`.
