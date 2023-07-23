#!/bin/bash
set -e

CONFIG_PATH=/data/options.json
SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
TOKEN_KEY=$(jq --raw-output '.token_key' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "protocol = tcp" >>  $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF
echo "tls_enable = true" >> $FRPC_CONF
echo "[hassio]" >> $FRPC_CONF
echo "type = tcp" >> $FRPC_CONF
echo "local_ip = 127.0.0.1" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = true" >> $FRPC_CONF
echo "use_compression = true" >> $FRPC_CONF

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
