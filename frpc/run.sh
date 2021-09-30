#!/bin/bash
set -e

bashio::addon.options > /data/options.json
# CONFIG_PATH=/data/options.json

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
DOMAIN_PROTOCOL=$(bashio::config 'domain_protocol')
DOMAINS=$(bashio::config 'domains')
CUSTOM_NAME=$(bashio::config 'custom_name')
PROXY_PROTOCOL_VERSION=$(bashio::config 'proxy_protocol_version')

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

if [ ! $CUSTOM_NAME ]; then
  CUSTOM_NAME=frpconnect
  echo Using default http name $CUSTOM_NAME
fi

if [ ! $BALANCING_GROUP ]; then
  BALANCING_GROUP=frpweb
  echo Using default balancing group name $BALANCING_GROUP
fi

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
echo "group = $BALANCING_GROUP" >> $FRPC_CONF
echo "group_key = $BALANCING_GROUP_KEY" >> $FRPC_CONF
if [ "$DOMAIN_PROTOCOL" = "custom_domains" ]; then
echo "custom_domains = $DOMAINS" >> $FRPC_CONF
elif [ "$DOMAIN_PROTOCOL" = "subdomain" ]; then
echo "subdomain = $DOMAINS" >> $FRPC_CONF
fi

elif [ "$FRP_TYPE" = "https" ]; then
echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = token" >> $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF

echo "[$CUSTOM_NAME]" >> $FRPC_CONF
echo "type = https" >> $FRPC_CONF
echo "local_ip = $LOCAL_IP" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = $USE_ENCRYPTION" >> $FRPC_CONF
echo "use_compression = $USE_COMPRESSION" >> $FRPC_CONF
if [ "$DOMAIN_PROTOCOL" = "custom_domains" ]; then
echo "custom_domains = $DOMAINS" >> $FRPC_CONF
elif [ "$DOMAIN_PROTOCOL" = "subdomain" ]; then
echo "subdomain = $DOMAINS" >> $FRPC_CONF
fi
echo "proxy_protocol_version = $PROXY_PROTOCOL_VERSION" >> $FRPC_CONF

elif [ "$FRP_TYPE" = "http2https" ]; then
echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "authentication_method = token" >> $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF

echo "[$CUSTOM_NAME]" >> $FRPC_CONF
echo "type = http" >> $FRPC_CONF
echo "use_encryption = $USE_ENCRYPTION" >> $FRPC_CONF
echo "use_compression = $USE_COMPRESSION" >> $FRPC_CONF
if [ "$DOMAIN_PROTOCOL" = "custom_domains" ]; then
echo "custom_domains = $DOMAINS" >> $FRPC_CONF
elif [ "$DOMAIN_PROTOCOL" = "subdomain" ]; then
echo "subdomain = $DOMAINS" >> $FRPC_CONF
fi
echo "group = $BALANCING_GROUP" >> $FRPC_CONF
echo "group_key = $BALANCING_GROUP_KEY" >> $FRPC_CONF
echo "plugin = http2https" >> $FRPC_CONF
echo "plugin_local_addr = $LOCAL_IP:$LOCAL_PORT" >> $FRPC_CONF
echo "plugin_host_header_rewrite = $LOCAL_IP" >> $FRPC_CONF
echo "plugin_header_X-From-Where = frp" >> $FRPC_CONF
fi

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
