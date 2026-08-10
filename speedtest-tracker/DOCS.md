# Speedtest Tracker

Self-hosted internet performance tracking: scheduled Ookla speedtests with
history, charts, and alerts.

This add-on is an **unofficial, community-maintained wrapper**. Credit
chain: the application itself is
[alexjustesen/speedtest-tracker](https://github.com/alexjustesen/speedtest-tracker)
(MIT licensed); the Docker image it runs on is built by
[LinuxServer.io](https://github.com/linuxserver/docker-speedtest-tracker)
(their build scripts are GPL-3.0). This repository only adds the thin
Home Assistant integration layer on top.

## Options

| Option | Purpose |
|---|---|
| `app_url` | The URL you'll actually reach this add-on at, e.g. `http://homeassistant.local:8087`. Used to generate links in notifications/emails -- set it to match your real setup. |
| `timezone` | Container and display timezone, e.g. `Europe/Berlin`. |
| `admin_name` / `admin_email` / `admin_password` | Initial admin account. **Only used once**, when the account is created on first start -- see below. |
| `speedtest_schedule` | Cron expression for automatic tests, e.g. `0 */6 * * *` for every 6 hours. Leave blank to disable scheduled tests (you can still run them manually from the UI). |
| `speedtest_servers` | Comma-separated Ookla server IDs to test against. Leave blank to auto-select the nearest server. |

## The admin account is a one-time thing

`admin_name`/`admin_email`/`admin_password` only take effect when the
admin account is created during the very first start -- changing them
later in the add-on configuration has no effect, because the app doesn't
re-read them afterward. **Set `admin_password` before starting the add-on
for the first time.** If you don't, Speedtest Tracker falls back to its
own built-in default password (`password`) -- the add-on logs a warning
about this on first start if you forgot.

To change credentials after the fact, use Speedtest Tracker's own admin
UI, or see Troubleshooting below.

## Data and updates

Speedtest Tracker only supports SQLite in this add-on (no external
database options are exposed). Its database, encryption key, and logs
live in the add-on's own persistent storage, so they survive add-on
updates and restarts.

During Home Assistant backups the add-on is stopped for a few seconds
(`backup: cold`) so the SQLite database is captured in a consistent
state; it starts again automatically afterwards.

## Troubleshooting

**Forgot the admin password:** reset it via the app's own console command.
With the SSH & Terminal add-on (or any way to run `docker exec`):

```bash
docker exec -it addon_speedtest-tracker php /app/www/artisan app:user-reset-password
```

It'll prompt for the account's email and a new password.

**Can't reach the web UI:** double check `app_url` matches how you're
actually accessing it, and that port `8087` isn't blocked or already used
by something else on your network.

**Scheduled tests aren't running:** confirm `speedtest_schedule` is a
valid 5-field cron expression and isn't empty -- an empty value disables
scheduling entirely.
