#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
FRP_TYPE=$(jq --raw-output '.frp_type' $CONFIG_PATH)
TOKEN_KEY=$(jq --raw-output '.token_key // empty' $CONFIG_PATH)
LOCAL_IP=$(jq --raw-output '.local_ip' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
USE_ENCRYPTION=$(jq --raw-output '.use_encryption' $CONFIG_PATH)
USE_COMPRESSION=$(jq --raw-output '.use_compression' $CONFIG_PATH)
BALANCING_GROUP=$(jq --raw-output '.balancing_group // empty' $CONFIG_PATH)
BALANCING_GROUP_KEY=$(jq --raw-output '.balancing_group_key // empty' $CONFIG_PATH)
# HEALTH_CHECK_TYPE=$(jq --raw-output '.health_check_type' $CONFIG_PATH)
# HEALTH_CHECK_TIMEOUT_S=$(jq --raw-output '.health_check_timeout_s' $CONFIG_PATH)
# HEALTH_CHECK_MAX_FAILED=$(jq --raw-output '.health_check_max_failed' $CONFIG_PATH)
# HEALTH_CHECK_INTERVAL_S=$(jq --raw-output '.health_check_interval_s' $CONFIG_PATH)
CUSTOM_DOMAINS=$(jq --raw-output '.custom_domains' $CONFIG_PATH)
CUSTOM_NAME=$(jq --raw-output '.custom_name' $CONFIG_PATH)
SERVER_CRT=$(jq --raw-output '.server_crt' $CONFIG_PATH)
SERVER_KEY=$(jq --raw-output '.server_key' $CONFIG_PATH)
SSL_PHHR=$(jq --raw-output '.ssl_phhr' $CONFIG_PATH)
# PROXY_PROTOCOL_VERSION=$(jq --raw-output '.proxy_protocol_version // empty' $CONFIG_PATH)

FRP_PATH=/var/frp
FRP_PATH_SSL=$FRP_PATH/ssl
FRPC_CONF=$FRP_PATH/frpc.ini
FRPC_CONF_CERT=$FRP_PATH_SSL/fullchain.pem
FRPC_CONF_KEY=$FRP_PATH_SSL/privkey.pem

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

if [ ! $CUSTOM_NAME ]; then
  CUSTOM_NAME=web
  echo Using default http name $CUSTOM_NAME
fi

#if [ ! $BALANCING_GROUP ]; then
#  BALANCING_GROUP=web
#  echo Using default balancing group name $BALANCING_GROUP
#fi

if [ "$FRP_TYPE" = "http" ]; then
echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = token" >> $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF

echo "[$CUSTOM_NAME]" >> $FRPC_CONF
echo "type = http" >> $FRPC_CONF
echo "local_ip = $LOCAL_IP" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = $USE_ENCRYPTION" >> $FRPC_CONF
echo "use_compression = $USE_COMPRESSION" >> $FRPC_CONF
echo "proxy_protocol_version = $PROXY_PROTOCOL_VERSION" >> $FRPC_CONF
echo "group = $BALANCING_GROUP" >> $FRPC_CONF
echo "group_key = $BALANCING_GROUP_KEY" >> $FRPC_CONF
# echo "health_check_type = $HEALTH_CHECK_TYPE" >> $FRPC_CONF
# echo "health_check_url = /status" >> $FRPC_CONF
# echo "health_check_timeout_s = $HEALTH_CHECK_TIMEOUT_S" >> $FRPC_CONF
# echo "health_check_max_failed = $HEALTH_CHECK_MAX_FAILED" >> $FRPC_CONF
# echo "health_check_interval_s = $HEALTH_CHECK_INTERVAL_S" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF

elif [ "$FRP_TYPE" = "https" ]; then
echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = token" >> $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF

echo "[$CUSTOM_NAME]" >> $FRPC_CONF
echo "type = https" >> $FRPC_CONF
#echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = $USE_ENCRYPTION" >> $FRPC_CONF
echo "use_compression = $USE_COMPRESSION" >> $FRPC_CONF
echo "custom_domains = $CUSTOM_DOMAINS" >> $FRPC_CONF
# echo "group = $BALANCING_GROUP" >> $FRPC_CONF
# echo "group_key = $BALANCING_GROUP_KEY" >> $FRPC_CONF
echo "plugin = https2http" >> $FRPC_CONF
echo "plugin_local_addr = $LOCAL_IP" >> $FRPC_CONF
echo "plugin_crt_path = $SERVER_CRT" >> $FRPC_CONF
echo "plugin_key_path = $SERVER_KEY" >> $FRPC_CONF
echo "plugin_host_header_rewrite = $SSL_PHHR" >> $FRPC_CONF
echo "plugin_header_X-From-Where = frp" >> $FRPC_CONF
# echo "proxy_protocol_version = $PROXY_PROTOCOL_VERSION" >> $FRPC_CONF
fi

chmod 600 /var/frp/ssl/fullchain.pem
chmod 600 /var/frp/ssl/privkey.pem
cp "$FRPC_CONF_CERT" "/ssl/"
cp "$FRPC_CONF_KEY" "/ssl/"

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
