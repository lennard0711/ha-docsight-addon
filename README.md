# DOCSight Home Assistant Add-on Repository

Home Assistant Supervisor add-on repository that packages
[DOCSight](https://github.com/itsDNNS/docsight) (MIT licensed) — a
self-hosted DOCSIS evidence system for proving cable signal problems and bad
ISP performance — as an installable add-on.

This is an **unofficial, community-maintained wrapper**, not affiliated with
DOCSight's author. It builds its own image on top of the upstream
`ghcr.io/itsdnns/docsight` image rather than referencing it directly, so
multi-arch support and add-on integration (options, host networking) are
controlled here.

> **Note:** This repository's packaging (Dockerfile, `config.yaml`,
> `run.sh`, CI workflow, docs) was created with the help of an AI coding
> assistant (Claude) and reviewed by me, Lennard Indlekofer, to the best of
> my knowledge. If you spot an issue, please open an issue or PR.

## Adding this repository to Home Assistant

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮** menu (top right) → **Repositories**.
3. Paste this repository's URL and click **Add**:
   ```
   https://github.com/lennard0711/ha-docsight-addon
   ```
4. The **DOCSight** add-on will appear in the store. Install, configure, and
   start it.

See [docsight/DOCS.md](docsight/DOCS.md) for configuration details,
including which settings belong in the add-on's Options tab versus
DOCSight's own `/settings` UI, and why `host_network` is required.

## Repository contents

- `docsight/` — the add-on itself (`config.yaml`, `Dockerfile`, `build.yaml`,
  `run.sh`, docs, translations).
- `.github/workflows/build.yml` — builds and publishes a multi-arch
  (`aarch64` + `amd64`) image to GHCR whenever a GitHub release is
  published.
- `renovate.json` — keeps the pinned upstream DOCSight image tag current.

## License

This repository's own files (add-on packaging, Dockerfile, scripts, CI) are
[MIT licensed](LICENSE), matching upstream's license terms.

DOCSight itself is a separate work, MIT licensed by its author, Dennis Braun
(itsDNNS) — this repository does not bundle its source, only builds on top
of the upstream image. See the [upstream repository](https://github.com/itsDNNS/docsight)
for its license text.
