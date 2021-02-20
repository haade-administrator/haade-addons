#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
AUTH_METHOD=$(jq --raw-output '.authentication_method // empty' $CONFIG_PATH)
TOKEN=$(jq --raw-output '.token // empty' $CONFIG_PATH)
LOCAL_IP=$(jq --raw-output '.local_ip' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
CUSTOM_DOMAINS=$(jq --raw-output '.custom_domains' $CONFIG_PATH)
ADMIN_ADDR=$(jq --raw-output '.admin_addr' $CONFIG_PATH)
ADMIN_PORT=$(jq --raw-output '.admin_port' $CONFIG_PATH)
ADMIN_USER=$(jq --raw-output '.admin_user' $CONFIG_PATH)
ADMIN_PWD=$(jq --raw-output '.admin_pwd' $CONFIG_PATH)

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = $AUTH_METHOD" >> $FRPC_CONF
echo "token = $TOKEN" >> $FRPC_CONF
echo "admin_addr = $ADMIN_ADDR" >> $FRPC_CONF
echo "admin_port = $ADMIN_PORT" >> $FRPC_CONF
echo "admin_user = $ADMIN_USER" >> $FRPC_CONF
echo "admin_pwd = $ADMIN_PWD" >> $FRPC_CONF
echo "<br/>"
echo "[web]" >> $FRPC_CONF
echo "type = http" >> $FRPC_CONF
echo "local_ip = $LOCAL_IP" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
