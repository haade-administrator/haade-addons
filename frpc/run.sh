#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
TOKEN_KEY=$(jq --raw-output '.token_key // empty' $CONFIG_PATH)
LOCAL_IP=$(jq --raw-output '.local_ip' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
USE_ENCRYPTION=$(jq --raw-output '.use_encryption' $CONFIG_PATH)
USE_COMPRESSION=$(jq --raw-output '.use_compression' $CONFIG_PATH)
BALANCING_GROUP=$(jq --raw-output '.balancing_group // empty' $CONFIG_PATH)
BALANCING_GROUP_KEY=$(jq --raw-output '.balancing_group_key // empty' $CONFIG_PATH)
HEALTH_CHECK_TYPE=$(jq --raw-output '.health_check_type' $CONFIG_PATH)
HEALTH_CHECK_TIMEOUT_S=$(jq --raw-output '.health_check_timeout_s' $CONFIG_PATH)
HEALTH_CHECK_MAX_FAILED=$(jq --raw-output '.health_check_max_failed' $CONFIG_PATH)
HEALTH_CHECK_INTERVAL_S=$(jq --raw-output '.health_check_interval_s' $CONFIG_PATH)
CUSTOM_DOMAINS=$(jq --raw-output '.custom_domains' $CONFIG_PATH)
HTTP_NAME=$(jq --raw-output '.http_name // empty' $CONFIG_PATH)
FRP_TYPE=$(jq --raw-output '.type' $CONFIG_PATH)
PROXY_PROTOCOL_VERSION=$(jq --raw-output '.proxy_protocol_version' $CONFIG_PATH)

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

if [ ! $HTTP_NAME ]; then
  HTTP_NAME=web
  echo Using default proxy name $HTTP_NAME
fi

if [ ! $BALANCING_GROUP ]; then
  BALANCING_GROUP=web
  echo Using default proxy name $BALANCING_GROUP
fi

echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = token" >> $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF
\
echo "[$HTTP_NAME]" >> $FRPC_CONF
echo "type = $FRP_TYPE" >> $FRPC_CONF
echo "local_ip = $LOCAL_IP" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = $USE_ENCRYPTION" >> $FRPC_CONF
echo "use_compression = $USE_COMPRESSION" >> $FRPC_CONF
# echo "proxy_protocol_version = $PROXY_PROTOCOL_VERSION" >> $FRPC_CONF
echo "group = $BALANCING_GROUP" >> $FRPC_CONF
echo "group_key = $BALANCING_GROUP_KEY" >> $FRPC_CONF
# echo "health_check_type = $HEALTH_CHECK_TYPE" >> $FRPC_CONF
# echo "health_check_url = /status" >> $FRPC_CONF
# echo "health_check_timeout_s = $HEALTH_CHECK_TIMEOUT_S" >> $FRPC_CONF
# echo "health_check_max_failed = $HEALTH_CHECK_MAX_FAILED" >> $FRPC_CONF
# echo "health_check_interval_s = $HEALTH_CHECK_INTERVAL_S" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
