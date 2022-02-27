ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:11.0.1
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ARG FRP_VERSION=0.39.1

RUN apk update \
     && apk add --no-cache openssl jq wget curl nano

RUN set -x \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "armhf" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "armv8" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && URL_VERSION="https://raw.githubusercontent.com/haade-administrator/haade-addons/master/version.json" \
    && FRP_VERSION=$(curl -s $URL_VERSION | jq -e -r '.frp') \
    && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && tar -zxf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && mv frp_${FRP_VERSION}_linux_${ARCH} /var \
    && mv /var/frp_${FRP_VERSION}_linux_${ARCH} /var/frp \
    && rm -rf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && cd /var/frp \
    && rm -rf frps frps.ini frps_full.ini


# Copy root filesystem
# COPY rootfs /  

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

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
    maintainer="Nicolas Rodriguez <administrateur@haade.fr>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Nicolas Rodriguez <administrateur@haade.fr>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

