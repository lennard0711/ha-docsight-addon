# Builds on top of the upstream DOCSight image so multi-arch support and
# tooling (jq for options.json parsing) are controlled here rather than
# depending on whatever upstream publishes.
#
# Upstream base is Debian, ENTRYPOINT is /entrypoint.sh (fixes /data
# ownership as root, then execs `gosu appuser "$@"`).
#
# BUILD_FROM is injected by the Home Assistant builder from build.yaml.
# aarch64 and amd64 point at the same tag because the upstream image is
# itself a multi-arch manifest list; buildx picks the right platform.
ARG BUILD_FROM=ghcr.io/itsdnns/docsight:v2026-08-21.1
FROM ${BUILD_FROM}

# jq parses options.json; curl queries the Supervisor API (MQTT service
# auto-configuration).
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq curl \
    && rm -rf /var/lib/apt/lists/*

# DOCSight's scheduled backup feature writes to /backup by default, which
# isn't configurable via environment variable. Symlinking it into /data
# (the add-on's persistent volume, included in Home Assistant backups)
# means backups survive image updates without any settings change. The
# manual "download backup" button is unaffected -- it streams straight to
# the browser and never touches /backup.
RUN rm -rf /backup && ln -s /data/backups /backup

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
# Declaring a new ENTRYPOINT resets any CMD inherited from the base image,
# so it has to be re-declared here for run.sh's "$@" to receive it.
CMD ["python", "-m", "app.main"]
