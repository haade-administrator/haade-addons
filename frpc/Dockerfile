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
ARG BUILD_ARCH=aarch64
ARG ARCH=arm64

ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ARG FRP_VERSION=0.51.1

RUN apk update \
     && apk add --no-cache openssl jq wget curl nano

RUN set -x \
    && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && tar -zxf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && mv frp_${FRP_VERSION}_linux_${ARCH} /var \
    && mv /var/frp_${FRP_VERSION}_linux_${ARCH} /var/frp \
    && rm -rf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz \
    && cd /var/frp \
    && rm -rf frps frps.ini frps_full.ini

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
