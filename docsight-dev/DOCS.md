# DOCSight (dev: Ingress fix test)

**Temporary add-on.** Built from itsDNNS/docsight commit `3cc2b4d`
(unreleased fix for
[itsDNNS/docsight#781](https://github.com/itsDNNS/docsight/issues/781):
DOCSight breaking when served under a URL sub-path, e.g. Home Assistant
Ingress). Its only purpose is to verify that fix against a real Ingress
setup before it ships in the regular `docsight` add-on. Safe to install
alongside the regular add-on -- separate slug, image and port.

Demo mode is on by default, so no real modem is needed.

## What to check

Open this add-on from Settings > Add-ons (or the sidebar, if you enable
"Show in sidebar" on its info page) and go through:

- setup/login, dashboard, logout, and login again
- Settings and at least one module page
- browser dev tools: no missing assets (404s), unexpected redirects to
  the bare origin (outside the Ingress path), or console errors
- if your browser offers it in this context: PWA installation

## How the Ingress path is wired up

`run.sh` asks the Supervisor API for this add-on's own assigned Ingress
path (`ingress_entry`) at startup and passes it to DOCSight via
`BASE_PATH` -- this is the untested part. If you see anything odd, check
the add-on's log first; it prints what it resolved (or why it fell back
to root mode).

## Cleanup

Uninstall this add-on when done -- it's not meant to stick around.
