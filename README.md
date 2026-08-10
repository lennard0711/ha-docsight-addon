# Home Assistant Add-on Repository

Home Assistant Supervisor add-on repository packaging two self-hosted apps
as installable add-ons:

- **[DOCSight](https://github.com/itsDNNS/docsight)** (MIT licensed) — a
  self-hosted DOCSIS evidence system for proving cable signal problems and
  bad ISP performance.
- **[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker)**
  (MIT licensed, built on the
  [LinuxServer.io](https://github.com/linuxserver/docker-speedtest-tracker)
  image) — scheduled Ookla speedtests with history, charts, and alerts.

Both are **unofficial, community-maintained wrappers**, not affiliated with
either project's authors. Each builds its own image on top of the
respective upstream image rather than referencing it directly, so multi-arch
support and add-on integration (options, persistent storage) are controlled
here.

> **Note:** This repository's packaging (Dockerfiles, `config.yaml`,
> `run.sh`, CI workflows, docs) was created with the help of an AI coding
> assistant (Claude) and reviewed by me, Lennard Indlekofer, to the best of
> my knowledge. If you spot an issue, please open an issue or PR.

## Adding this repository to Home Assistant

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮** menu (top right) → **Repositories**.
3. Paste this repository's URL and click **Add**:
   ```
   https://github.com/lennard0711/ha-docsight-addon
   ```
4. Both **DOCSight** and **Speedtest Tracker** will appear in the store.
   Install, configure, and start whichever you need.

See [docsight/DOCS.md](docsight/DOCS.md) and
[speedtest-tracker/DOCS.md](speedtest-tracker/DOCS.md) for configuration
details specific to each add-on.

## Repository contents

- `docsight/` — the DOCSight add-on (`config.yaml`, `Dockerfile`,
  `build.yaml`, `run.sh`, docs, translations).
- `speedtest-tracker/` — the Speedtest Tracker add-on, same layout.
- `.github/workflows/build.yml` — builds and publishes a multi-arch
  (`aarch64` + `amd64`) image to GHCR for whichever add-on a GitHub release
  is for (tag format `<addon-slug>/<version>`), or when dispatched by the
  auto-release workflow.
- `.github/workflows/auto-release.yml` — after a merged upstream bump to
  either add-on, automatically bumps its version, updates its changelog,
  creates the release, and dispatches the build — merging the Renovate PR
  is the only manual step.
- `.github/workflows/smoke-test.yml` — builds and boots both add-ons'
  images on every push/PR touching them, with an add-on-specific
  functional check each.
- `renovate.json` — watches for new upstream image tags for both add-ons
  and opens update PRs.

## License

This repository's own files (add-on packaging, Dockerfile, scripts, CI) are
[MIT licensed](LICENSE), matching upstream's license terms.

DOCSight itself is a separate work, MIT licensed by its author, Dennis Braun
(itsDNNS) — this repository does not bundle its source, only builds on top
of the upstream image. See the [upstream repository](https://github.com/itsDNNS/docsight)
for its license text.

Speedtest Tracker is likewise a separate work: the app itself is MIT
licensed by [alexjustesen](https://github.com/alexjustesen/speedtest-tracker),
and the Docker image it runs on is built by
[LinuxServer.io](https://github.com/linuxserver/docker-speedtest-tracker)
under GPL-3.0 build scripts. This repository bundles neither source, only
builds on top of the upstream image.
