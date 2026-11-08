# Changelog

## v2026-11-02.1-addon.2

> **Added modem types to the `modem_type` option (new upstream drivers, added automatically):** pyur_fast3896, sb8200_cbn

_Re-release of the add-on with the upstream release notes (no upstream change)._

#### Highlights

- **Security updates for PDF handling and image processing.** pypdf 6.21.4 fixes several denial-of-service issues with crafted PDF files, which matters for imported BNetzA measurement reports. Pillow moves to 13.0.0 and certifi to 2026.10.23. ([itsDNNS/docsight#1093](https://github.com/itsDNNS/docsight/pull/1093), [itsDNNS/docsight#1100](https://github.com/itsDNNS/docsight/pull/1100))
- **The setup wizard asks for the poll interval in seconds.** It used to say minutes while DOCSight always used seconds, so entering 60 for an hour polled every minute, and a small value blocked the final step without a visible message. Out-of-range values are now flagged right where they are typed. ([itsDNNS/docsight#1084](https://github.com/itsDNNS/docsight/pull/1084))
- **Corrected translations of DOCSIS terms.** Polling was translated as voting or opinion surveys, and upstream, downstream, US/DS and power in non-technical senses such as rivers, the United States or political power. More than 1,700 strings across 22 languages now use the technical terms. ([itsDNNS/docsight#1085](https://github.com/itsDNNS/docsight/pull/1085), [itsDNNS/docsight#1088](https://github.com/itsDNNS/docsight/pull/1088))

#### Special thanks

- [@septatrix](https://github.com/septatrix) for reporting and analysing the wrong poll interval unit in the setup wizard ([itsDNNS/docsight#1083](https://github.com/itsDNNS/docsight/issues/1083)).

#### Maintenance

- CI fails when a dependency lock drifts from its inputs, so the Windows locks can no longer fall behind `requirements.txt`. ([itsDNNS/docsight#1082](https://github.com/itsDNNS/docsight/pull/1082))
- Tests that create symlinks skip only where Windows denies the privilege, and the compact axis label test no longer depends on the machine locale. ([itsDNNS/docsight#1086](https://github.com/itsDNNS/docsight/pull/1086), [itsDNNS/docsight#1087](https://github.com/itsDNNS/docsight/pull/1087))
- Browser tests run on Ubuntu 26.04 with Playwright 1.64.1. ([itsDNNS/docsight#1100](https://github.com/itsDNNS/docsight/pull/1100))
- Updated py-vapid to 1.9.6 and soupsieve to 3.0.4, plus GitHub Actions updates. Dependabot now groups minor and patch updates per ecosystem. ([itsDNNS/docsight#1092](https://github.com/itsDNNS/docsight/pull/1092), [itsDNNS/docsight#1079](https://github.com/itsDNNS/docsight/pull/1079), [itsDNNS/docsight#1098](https://github.com/itsDNNS/docsight/pull/1098), [itsDNNS/docsight#1099](https://github.com/itsDNNS/docsight/pull/1099), [itsDNNS/docsight#1077](https://github.com/itsDNNS/docsight/pull/1077), [itsDNNS/docsight#1080](https://github.com/itsDNNS/docsight/pull/1080), [itsDNNS/docsight#1081](https://github.com/itsDNNS/docsight/pull/1081), [itsDNNS/docsight#1089](https://github.com/itsDNNS/docsight/pull/1089))

#### Container images

- `ghcr.io/itsdnns/docsight:v2026-11-02.1`
- `ghcr.io/itsdnns/docsight:stable`
- `ghcr.io/itsdnns/docsight:latest`

Use `stable` to follow releases only; `latest` also follows changes on `main`.

#### Support the project

If DOCSight helps you understand and document your connection, you can support its continued development through [Ko-fi](https://ko-fi.com/itsdnns), [GitHub Sponsors](https://github.com/sponsors/itsDNNS) or [PayPal](https://paypal.me/itsDNNS).

**Full diff:** https://github.com/itsDNNS/docsight/compare/v2026-10-14.1...v2026-11-02.1

[Upstream release notes](https://github.com/itsDNNS/docsight/releases/tag/v2026-11-02.1)

## v2026-11-02.1-addon.1

- Update to upstream `v2026-11-02.1` (automated release).

## v2026-10-14.1-addon.1

- Update to upstream `v2026-10-14.1` (automated release).

## v2026-10-08.1-addon.1

- Update to upstream `v2026-10-08.1` (automated release).

## v2026-09-16.1-addon.1

- Update to upstream `v2026-09-16.1` (automated release).

## v2026-09-06.1-addon.1

- Update to upstream `v2026-09-06.1` (automated release).

## v2026-08-30.1-addon.1

- Update to upstream `v2026-08-30.1` (automated release).

## v2026-08-21.1-addon.1

- Update to upstream `v2026-08-21.1` (automated release).

## v2026-08-13.1-addon.1

- Update to upstream DOCSight `v2026-08-13.1`, which adds URL path-prefix
  support (itsDNNS/docsight#783) plus module static-path hardening
  (#784) and report-period fixes.
- Home Assistant sidebar support via Ingress: new `web_ui` option,
  `ingress` (default) serves the UI through the sidebar, `direct` keeps
  the previous port-8765 behavior. The modes are mutually exclusive --
  DOCSight renders URLs for exactly one mount point.

  **If you access DOCSight directly on port 8765** (bookmark, your own
  reverse proxy), set `web_ui` to `direct` after updating.

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
