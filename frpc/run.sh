#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
AUTH_METHOD=$(jq --raw-output '.authentication_method // empty' $CONFIG_PATH)
TOKEN=$(jq --raw-output '.token // empty' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
CUSTOM_DOMAINS=$(jq --raw-output '.custom_domains' $CONFIG_PATH)
PROXY_NAME=$(jq --raw-output '.proxy_name // empty' $CONFIG_PATH)

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

if [ ! $PROXY_NAME ]; then
  PROXY_NAME=web
  echo Using default proxy name $PROXY_NAME
fi

echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = $AUTH_METHOD" >> $FRPC_CONF
echo "token = $TOKEN" >> $FRPC_CONF

echo "[$PROXY_NAME]" >> $FRPC_CONF
echo "type = http" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
