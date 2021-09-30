ARG BUILD_FROM
#ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:10.1.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base

RUN \
    apk update \
    && apk add --no-cache make \
    nodejs \
    npm \
    gcc \
    g++ \
    python3 \
    linux-headers udev \
    && mkdir /home/node \
    && mkdir /home/node/app \
    && curl -J -L -o /tmp/teleinfo2mqtt.tar.gz \
        "https://github.com/fmartinou/teleinfo-mqtt/archive/refs/tags/6.0.2.tar.gz" \
    && tar zxvf \
        /tmp/teleinfo2mqtt.tar.gz \
        --strip 1 -C /home/node/app \
    && cp Docker.entrypoint.sh /usr/bin/entrypoint.sh \
    && chmod +x /usr/bin/entrypoint.sh \
    && rm -f -r \
        /tmp/.[!.]* \
        /tmp/* \
    && cd /home/node/app \
    && rm -f -r \
        .[!.]* \
        *.md \
        Dockerfile \
        Makefile \
        *.sh

WORKDIR /home/node/app
ENV LOG_FORMAT=text

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Default Command
CMD ["node", "index"]

# Add TZDATA to allow easy local time configuration
RUN apk update \
    && apk add tzdata \
    && rm -rf /var/cache/apk/* \
    && cp app/ ./ \
    && npm ci --production

WORKDIR /
COPY rootfs/


# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Nicolas Rodriguez <nicolas@haade-addons>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Nicolas Rodriguez <nicolas@haade-addons>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
