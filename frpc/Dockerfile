ARG BUILD_FROM
FROM $BUILD_FROM

ENV FRP_VERSION 0.51.1
# Todo: Fix HACK
ENV ARCH arm64
ENV LANG C.UTF-8


WORKDIR /app
COPY run.sh .

#update and install deps
RUN apk update && apk add --no-cache openssl wget

#download frp
RUN wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz

#extract frpc-binary
RUN tar -zxf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz frp_${FRP_VERSION}_linux_${ARCH}/frpc

#make symlink and delete archive
RUN rm *.tar.gz && ln -s $(ls frp_*/* -r) frpc
CMD [ "./run.sh" ]