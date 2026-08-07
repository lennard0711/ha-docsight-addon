# Own Dockerfile on top of the upstream DOCSight image, so multi-arch
# support and tooling (jq for options.json parsing) are controlled here
# instead of depending on whatever upstream happens to publish.
#
# Verified upstream facts (see repo README for how these were checked):
#   - Base OS: Debian (trixie) -> apt-get, not apk
#   - jq is NOT preinstalled upstream
#   - Upstream ENTRYPOINT: /entrypoint.sh, CMD: ["python", "-m", "app.main"]
#     entrypoint.sh fixes /data ownership as root, then execs
#     `gosu appuser "$@"` -- it must stay in the chain, not be replaced.
# BUILD_FROM is injected by the Home Assistant builder from build.yaml's
# build_from map. Both aarch64 and amd64 point at the same upstream tag
# because ghcr.io/itsdnns/docsight is itself a multi-arch manifest list
# (verified: it publishes amd64, arm64 and armv7 for this tag) -- buildx
# resolves the correct platform variant automatically.
ARG BUILD_FROM=ghcr.io/itsdnns/docsight:v2026-08-07.1
FROM ${BUILD_FROM}

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
