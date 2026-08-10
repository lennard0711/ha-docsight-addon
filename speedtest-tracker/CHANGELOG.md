# Changelog

## v1.14.7-ls165-addon.2

- Home Assistant backups now stop the add-on briefly (`backup: cold`) so
  the SQLite database is captured in a consistent state.
- Hardened the startup script (strict shell mode, safer option parsing).

## v1.14.7-ls165-addon.1

- Initial release. Wraps LinuxServer.io's speedtest-tracker image
  `v1.14.7-ls165` (upstream app v1.14.7).
