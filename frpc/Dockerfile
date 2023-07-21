ARG BUILD_ARCH
ARG BUILD_FROM
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ARG FRP_VERSION=0.51.1

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
