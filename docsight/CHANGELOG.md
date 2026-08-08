# Changelog

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
