# DOCSight for Home Assistant

Run [DOCSight](https://github.com/itsDNNS/docsight) as a Home Assistant
add-on: it monitors your DOCSIS cable modem and builds an evidence trail —
signal health, incidents, and complaint-ready exports you can hand to your
ISP.

This repository also packages
[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) as a
second add-on. It's here as DOCSight's companion: DOCSight can pull its
speedtest results in and correlate throughput with modem signal quality, so
a complaint isn't just "the internet is slow" but shows *when* speed dropped
and *what the line was doing at that moment*. You can also run it on its own
if you only want speed history.

Both are **unofficial community wrappers**, not affiliated with the original
projects.

**Requirements:** Home Assistant OS or Supervised, on `aarch64` or `amd64`
(32-bit ARM is not supported).

> **Note:** This repository's packaging was created with the help of an AI
> coding assistant (Claude) and reviewed by me to the
> best of my knowledge. If you spot a problem, please open an issue.

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Open the **⋮** menu (top right) → **Repositories**.
3. Add this URL:
   ```
   https://github.com/lennard0711/ha-docsight-addon
   ```
4. **DOCSight** and **Speedtest Tracker** now appear in the store. Install
   DOCSight, set its options, then start it. Add Speedtest Tracker if you
   want throughput history alongside the signal data.

Full option reference and troubleshooting per add-on:
[DOCSight docs](docsight/DOCS.md) ·
[Speedtest Tracker docs](speedtest-tracker/DOCS.md)

## Setting up DOCSight

- Set `modem_url` to your modem's diagnostic interface (often
  `http://192.168.100.1`, sometimes your router's address) and pick the
  matching `modem_type`. Not sure yet? Turn on `demo_mode` first to explore
  the UI with sample data.
- **MQTT usually needs no configuration.** If you run the Mosquitto add-on
  and leave the MQTT username and password empty, DOCSight connects to it
  automatically and its sensors show up in Home Assistant.
- **Decide how you want to open the UI.** With the default `web_ui: ingress`
  it opens from the Home Assistant sidebar (enable *Show in sidebar* on the
  add-on page). If you'd rather use port 8765 directly or put your own
  reverse proxy in front, set `web_ui: direct`. The two are mutually
  exclusive — DOCSight builds its links for exactly one of them, so the
  other one shows broken pages.

## Setting up Speedtest Tracker

- **Set `admin_password` before the very first start.** The admin account is
  created once, on the first run. Leave the password empty and the app falls
  back to its own default (`password`); changing the option later has no
  effect, you'd have to reset it from inside the app.
- Set `app_url` to the address you'll actually use, e.g.
  `http://homeassistant.local:8087`, so links in notifications work.
- It has no sidebar entry — the app can't run under a URL sub-path, which
  the sidebar requires. Open it on port 8087.

## Connecting the two

Once both add-ons run, tell DOCSight where to find your speedtest results:

1. In Speedtest Tracker, create an API token with the **Read Results**
   permission (**Settings → API**, or go straight to `/admin/api-tokens`)
   and copy it — it's shown only once.
2. In DOCSight, open **Settings** and fill in:
   - **Speedtest Tracker URL:** `http://localhost:8087`
     (DOCSight runs on the host network and Speedtest Tracker publishes port
     8087 there, so this reaches it without any extra configuration)
   - **API Token:** the token from step 1
3. DOCSight now imports the results and shows throughput next to the signal
   measurements.

These two settings live in DOCSight's own Settings page, not in the add-on
options.

## Running them

**Updates** arrive like any other add-on — when a new version is available,
Home Assistant shows it under **Settings → Add-ons**. New upstream releases
are normally packaged within a few days of appearing. Read the add-on's
changelog before updating; anything that needs your attention is called out
there.

**Backups** are handled by Home Assistant. Both add-ons are stopped for a
few seconds during a backup so their databases are saved in a consistent
state, then started again. Their data — measurement history, settings, and
DOCSight's scheduled backup exports — lives in the add-on's own storage and
is included in every full or per-add-on backup.

**If something breaks,** the add-on's **Log** tab is the first place to
look. DOCSight reports at startup which MQTT broker and UI mode it settled
on, and Speedtest Tracker warns on its first run if no admin password was
set. The troubleshooting sections in the docs linked above cover the common
cases.

## Support

Problems with **installing, configuring, or updating the add-ons** belong in
this repository's [issues](https://github.com/lennard0711/ha-docsight-addon/issues).

Problems with the **applications themselves** — a wrong measurement, a UI
bug, a missing feature — are best reported to the upstream projects
([DOCSight](https://github.com/itsDNNS/docsight/issues),
[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker/issues)),
since this repository only packages them.

## License

This repository's own packaging files are [MIT licensed](LICENSE).

The applications are separate works and are not bundled here — these add-ons
only build on top of the images their authors publish. DOCSight is MIT
licensed by Dennis Braun (itsDNNS). Speedtest Tracker is MIT licensed by
[alexjustesen](https://github.com/alexjustesen/speedtest-tracker); the image
it runs on is built by
[LinuxServer.io](https://github.com/linuxserver/docker-speedtest-tracker)
under GPL-3.0 build scripts.
