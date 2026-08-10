# Dev-only image for testing itsDNNS/docsight issue #781 against a real
# Home Assistant Ingress setup. BUILD_FROM is built locally from the
# upstream fix commit (not yet a published tag) -- see the repo README
# for how this image was produced.
ARG BUILD_FROM
FROM ${BUILD_FROM}

# curl is needed to resolve this add-on's own Ingress path from the
# Supervisor API at startup (see run.sh); jq parses options.json and
# that API response.
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq curl \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /backup && ln -s /data/backups /backup

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
CMD ["python", "-m", "app.main"]
