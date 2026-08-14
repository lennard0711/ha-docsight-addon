<h1 align="center">DOCSight for Home Assistant</h1>

<p align="center">
  <em>Your cable internet keeps dropping. Your ISP says everything looks fine.<br>
  This is how you prove otherwise.</em>
</p>

<p align="center">
  <img alt="DOCSight version" src="https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Flennard0711%2Fha-docsight-addon%2Fmain%2Fdocsight%2Fconfig.yaml&query=%24.version&label=DOCSight&color=blue">
  <img alt="Speedtest Tracker version" src="https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Flennard0711%2Fha-docsight-addon%2Fmain%2Fspeedtest-tracker%2Fconfig.yaml&query=%24.version&label=Speedtest%20Tracker&color=blue">
  <img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/lennard0711/ha-docsight-addon/build.yml?label=build">
  <img alt="Smoke test status" src="https://img.shields.io/github/actions/workflow/status/lennard0711/ha-docsight-addon/smoke-test.yml?label=smoke%20test">
  <img alt="License" src="https://img.shields.io/github/license/lennard0711/ha-docsight-addon">
</p>

[DOCSight](https://github.com/itsDNNS/docsight) watches your DOCSIS cable
modem around the clock and turns what it sees into evidence: signal health
over time, incidents as they happen, and exports you can actually put in
front of your provider.

This repository packages it as a Home Assistant add-on — install it from the
store, no Docker knowledge required — together with
[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) as its
companion. DOCSight pulls the speedtest results in and lines them up against
the signal data, so your complaint isn't "the internet is slow" but *"here is
the exact minute throughput collapsed, and here is what the line was doing at
that moment."*

<p align="center">
  <a href="https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Flennard0711%2Fha-docsight-addon">
    <img alt="Open your Home Assistant instance and add this add-on repository." src="https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg">
  </a>
</p>

> [!NOTE]
> Both add-ons are unofficial community wrappers, not affiliated with the
> original projects. The packaging was created with the help of an AI coding
> assistant (Claude) and reviewed by me to the best of my knowledge. If you
> spot a problem, please open an issue.

## Installation

Click the button above, or add it by hand:

1. **Settings → Add-ons → Add-on Store**
2. **⋮** menu (top right) → **Repositories**
3. Paste `https://github.com/lennard0711/ha-docsight-addon` and hit **Add**

**DOCSight** and **Speedtest Tracker** now show up in the store. Install
DOCSight, set its options, start it. Add Speedtest Tracker if you want
throughput history alongside the signal data.

**Requirements:** Home Assistant OS or Supervised, `aarch64` or `amd64`
(32-bit ARM is not supported).

Full option reference and troubleshooting:
[DOCSight docs](docsight/DOCS.md) ·
[Speedtest Tracker docs](speedtest-tracker/DOCS.md)

## Setting up DOCSight

Point it at your modem: set `modem_url` to the diagnostic interface (often
`http://192.168.100.1`, sometimes your router's address) and pick the
matching `modem_type`. Not sure it'll work? Flip on `demo_mode` first and
explore the UI with sample data.

> [!TIP]
> **MQTT needs no setup.** Running the Mosquitto add-on? Leave the MQTT
> username and password empty — DOCSight finds the broker on its own and its
> sensors appear in Home Assistant.

> [!IMPORTANT]
> **Pick one way to open the UI.** By default (`web_ui: ingress`) DOCSight
> lives in the Home Assistant sidebar — just enable *Show in sidebar* on the
> add-on page. Prefer port 8765 directly, or your own reverse proxy? Set
> `web_ui: direct`.
>
> You can't have both: DOCSight builds its links for exactly one of them, so
> whichever you didn't pick will serve broken pages.

## Setting up Speedtest Tracker

> [!WARNING]
> **Set `admin_password` before the very first start.** The admin account is
> created once, on the first run. Leave it empty and the app falls back to
> its own default (`password`) — changing the option afterwards does nothing,
> and you'd have to reset it from inside the app.

Set `app_url` to the address you'll actually use (e.g.
`http://homeassistant.local:8087`) so links in notifications point somewhere
useful.

It has no sidebar entry, by the way: the app can't run under a URL sub-path,
which the sidebar requires. Open it on port 8087.

## Connecting the two

With both add-ons running, tell DOCSight where the speedtest results live:

1. In **Speedtest Tracker**, create an API token with the **Read Results**
   permission (**Settings → API**, or head straight to `/admin/api-tokens`).
   Copy it — it's shown only once.
2. In **DOCSight**, open **Settings** and fill in:

   | Field | Value |
   |---|---|
   | Speedtest Tracker URL | `http://localhost:8087` |
   | API Token | the token from step 1 |

3. Done — DOCSight imports the results and shows throughput right next to the
   signal measurements.

> [!TIP]
> `localhost` really is correct here. DOCSight runs on the host network and
> Speedtest Tracker publishes port 8087 there, so the two find each other
> with no extra networking setup.

These two settings live in DOCSight's own Settings page, not in the add-on
options.

## Day-to-day

**Updates** show up under **Settings → Add-ons** like any other add-on. New
upstream releases are normally packaged within a few days. Skim the add-on's
changelog before updating — anything that needs your attention is called out
there.

**Backups** just work. Home Assistant stops each add-on for a few seconds
during a backup so its database is saved in a consistent state, then starts
it again. Measurement history, settings, and DOCSight's scheduled exports all
live in the add-on's own storage and ride along in every full or per-add-on
backup.

**Something off?** Start with the add-on's **Log** tab. DOCSight reports at
startup which MQTT broker and UI mode it settled on; Speedtest Tracker warns
on its first run if no admin password was set. The troubleshooting sections
in the docs above cover the usual suspects.

## Support

| What's wrong | Where it goes |
|---|---|
| Installing, configuring, or updating the add-ons | [Issues here](https://github.com/lennard0711/ha-docsight-addon/issues) |
| The apps themselves — wrong measurement, UI bug, missing feature | [DOCSight](https://github.com/itsDNNS/docsight/issues) · [Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker/issues) |

This repository only packages the applications, so bugs in the apps are best
reported to the people who build them.

## License

This repository's own packaging files are [MIT licensed](LICENSE).

The applications are separate works and aren't bundled here — these add-ons
build on top of the images their authors publish. DOCSight is MIT licensed by
Dennis Braun (itsDNNS). Speedtest Tracker is MIT licensed by
[alexjustesen](https://github.com/alexjustesen/speedtest-tracker); the image
it runs on is built by
[LinuxServer.io](https://github.com/linuxserver/docker-speedtest-tracker)
under GPL-3.0 build scripts.
