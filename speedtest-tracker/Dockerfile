# Builds on top of the LinuxServer.io speedtest-tracker image so the
# add-on-specific bootstrap (options.json -> env vars, APP_KEY generation)
# is controlled here. jq and openssl are already present in the base
# image, so no extra packages are needed.
#
# BUILD_FROM is injected by the Home Assistant builder from build.yaml.
# The upstream image is itself a multi-arch manifest (amd64, aarch64), so
# both archs point at the same tag.
ARG BUILD_FROM=ghcr.io/linuxserver/speedtest-tracker:v1.15.0-ls169
FROM ${BUILD_FROM}

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
