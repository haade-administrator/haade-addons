#!/usr/bin/env bashio

USERNAME=$(bashio::config 'username')

bashio::log.info "${USERNAME}"

SERVER_ADDR=$(bashio::config 'server_addr')
SERVER_PORT=$(bashio::config 'server_port')
FRP_TYPE=$(bashio::config 'frp_type')
TOKEN_KEY=$(bashio::config 'token_key')
LOCAL_IP=$(bashio::config 'local_ip')
LOCAL_PORT=$(bashio::config 'local_port')
USE_ENCRYPTION=$(bashio::config 'use_encryption')
USE_COMPRESSION=$(bashio::config 'use_compression')
BALANCING_GROUP=$(bashio::config 'balancing_group')
BALANCING_GROUP_KEY=$(bashio::config 'balancing_group_key')
# HEALTH_CHECK_TYPE=$(bashio::config 'health_check_type')
# HEALTH_CHECK_TIMEOUT_S=$(bashio::config 'health_check_timeout_s')
# HEALTH_CHECK_MAX_FAILED=$(bashio::config 'health_check_max_failed')
# HEALTH_CHECK_INTERVAL_S=$(bashio::config 'health_check_interval_s')
CUSTOM_DOMAINS=$(bashio::config 'custom_domains')
CUSTOM_NAME=$(bashio::config 'custom_name')
SERVER_CRT=$(bashio::config 'server_crt')
SERVER_KEY=$(bashio::config 'server_key')
SSL_PHHR=$(bashio::config 'ssl_phhr')
PROXY_PROTOCOL_VERSION=$(bashio::config 'proxy_protocol_version')

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini
FRP_PATH_SSL=$FRP_PATH/ssl
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
echo "proxy_protocol_version = $PROXY_PROTOCOL_VERSION" >> $FRPC_CONF
fi

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
