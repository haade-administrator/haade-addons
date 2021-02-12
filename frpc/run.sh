#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_IP=$(jq --raw-output '.server_ip' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
CUSTOM_DOMAINS=$(jq --raw-output '.custom_domains' $CONFIG_PATH)

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/conf/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_IP" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF

echo "[web]" >> $FRPC_CONF
echo "type = http" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
