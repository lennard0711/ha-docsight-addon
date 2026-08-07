# Changelog

## v2026-08-07.1-addon.2

- Fix container failing to start with only gosu's usage help printed to
  the log. Declaring a new `ENTRYPOINT` in the Dockerfile silently reset
  the `CMD` inherited from the upstream image to empty, so `run.sh` had
  nothing to hand off to `/entrypoint.sh`. `CMD` is now re-declared
  explicitly in the Dockerfile.

## v2026-08-07.1-addon.1

- Initial release. Wraps upstream DOCSight `v2026-08-07.1`.
