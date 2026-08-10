# DOCSight

Self-hosted DOCSIS evidence system for proving cable signal problems and bad
ISP performance. Tracks incidents, signal health, and complaint-ready
exports.

This add-on is an **unofficial, community-maintained wrapper** around
[itsDNNS/docsight](https://github.com/itsDNNS/docsight) (MIT licensed). All
credit for DOCSight itself goes to its author, Dennis Braun (itsDNNS); this
repository only packages the existing upstream Docker image for Home
Assistant OS.

## What you configure here vs. in DOCSight's own UI

DOCSight reads its configuration through a `ConfigManager` that resolves
every setting as **environment variable → `config.json` → default**, checked
on **every read**, not just at container start. Any setting exposed as an
environment variable therefore permanently overrides whatever value is saved
in DOCSight's own `/settings` page for that same key -- editing it in the UI
would appear to save, but the container's env var would keep winning on the
next read.

To avoid that trap, this add-on only exposes options for settings that:
- have an environment variable in DOCSight, **and**
- are genuinely meant to be fixed infrastructure config (which modem to
  poll, which MQTT broker to publish to), not something you'd want to tweak
  from DOCSight's UI later.

### Configured via the add-on Options tab

| Option | Purpose |
|---|---|
| `modem_type` | Which modem driver to use (see the dropdown for the full list) |
| `modem_url` | Base URL of your modem's admin/diagnostic interface |
| `modem_user` / `modem_password` | Modem admin credentials, if required |
| `poll_interval` | Seconds between modem polls |
| `log_level` | Container log verbosity |
| `mqtt_host` / `mqtt_port` / `mqtt_user` / `mqtt_password` | MQTT broker for Home Assistant integration. **Usually nothing to configure:** with the default host and no credentials set, the add-on fetches connection details automatically from the Mosquitto add-on via the Supervisor. Fill these in only for an external broker; leave `mqtt_host` blank to disable MQTT |
| `admin_password` | DOCSight's own admin login password |
| `demo_mode` | Runs DOCSight with 9 months of synthetic demo data instead of polling a real modem |

### Configured only in DOCSight's own `/settings` UI

Everything else -- notifications (webhook/Apprise/push), Smart Capture,
interface language, theme, ISP name, timezone, snapshot time, disabled
modules -- has **no environment variable in DOCSight at all**, so setting it
in the UI is safe and persists normally across add-on restarts.

## Why `host_network: true`

DOCSIS cable modems commonly expose their diagnostic/admin interface on a
separate private subnet from your LAN (frequently `192.168.100.1`), reachable
only from the segment the modem itself bridges onto. Running the container
in Home Assistant's isolated add-on network would prevent it from ever
reaching that subnet. `host_network: true` puts the container directly on
the host's network stack (the same as HAOS itself), so it can reach the
modem exactly as the host can.

## DOCSight's own backups/exports

DOCSight has two different things both called "backup":

- **The "download backup" button** in its UI streams a `.tar.gz` straight to
  your browser as a normal file download. It never touches the container's
  filesystem beyond a temp file it cleans up immediately -- nothing to
  configure, works the same as running DOCSight anywhere else.
- **Scheduled/automatic backups** (if enabled) are written server-side to
  `backup_path`, which defaults to `/backup` and isn't configurable via
  environment variable, only in DOCSight's own `/settings`.

This add-on redirects that scheduled-backup path into the add-on's own
persistent storage, which is automatically included in every full or
per-add-on Home Assistant backup you take -- so scheduled backups survive
image updates. You don't need to change anything in DOCSight's `/settings`
for this to work.

## Troubleshooting

**Can't reach the modem / "connection refused" errors polling `modem_url`:**
Verify your Home Assistant host (the Pi) is actually on the same Layer 2
segment as the modem's admin interface -- check with `ip route` / `ip addr`
on HAOS (via the OS-level SSH add-on) that the modem's subnet (e.g.
`192.168.100.0/24`) is reachable from an interface on the host, not just
from a separate VLAN or a router downstream of the modem.

**MQTT not publishing:** confirm the broker add-on (e.g. Mosquitto) is
running. With the default `mqtt_host` and blank credentials, the add-on
auto-configures itself from the Mosquitto add-on -- the add-on log shows
whether that worked at startup. If you configured credentials manually,
they must match a valid broker user. Leave `mqtt_host` blank if you don't
want MQTT enabled at all.

**Cleared `mqtt_host` but MQTT is still connecting:** an empty add-on option
means the environment variable is unset, and DOCSight then falls back to
whatever is stored in its own `config.json` -- so if you ever saved an MQTT
host through DOCSight's `/settings` UI, that value takes over. Clear the
MQTT host in DOCSight's `/settings` as well to fully disable it.

**Changed a modem/MQTT setting in DOCSight's UI and it didn't stick:** that's
expected for any of the options listed above under "Configured via the
add-on Options tab" -- change it in the add-on configuration instead, then
restart the add-on.
