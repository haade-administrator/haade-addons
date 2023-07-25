ARG BUILD_FROM
FROM $BUILD_FROM

ENV FRP_VERSION 0.51.1
# Todo: Fix HACK
ENV ARCH arm64
ENV LANG C.UTF-8


WORKDIR /app

RUN apk update && apk add --no-cache openssl wget
RUN wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz
RUN tar -zxf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz
RUN mv frpc .frpc
RUN rm *
RUN mv .frpc frpc

COPY run.sh .
CMD [ "./run.sh" ]