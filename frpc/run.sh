#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER_ADDR=$(jq --raw-output '.server_addr' $CONFIG_PATH)
SERVER_PORT=$(jq --raw-output '.server_port' $CONFIG_PATH)
FRP_TYPE=$(jq --raw-output '.frp_type' $CONFIG_PATH)
TOKEN_KEY=$(jq --raw-output '.token_key' $CONFIG_PATH)
LOCAL_IP=$(jq --raw-output '.local_ip' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
USE_ENCRYPTION=$(jq --raw-output '.use_encryption' $CONFIG_PATH)
USE_COMPRESSION=$(jq --raw-output '.use_compression' $CONFIG_PATH)
BALANCING_GROUP=$(jq --raw-output '.balancing_group' $CONFIG_PATH)
BALANCING_GROUP_KEY=$(jq --raw-output '.balancing_group_key' $CONFIG_PATH)
DOMAIN_PROTOCOL=$(jq --raw-output '.domain_protocol' $CONFIG_PATH)
DOMAINS=$(jq --raw-output '.domains' $CONFIG_PATH)
CUSTOM_NAME=$(jq --raw-output '.custom_name' $CONFIG_PATH)
PROXY_PROTOCOL_VERSION=$(jq --raw-output '.proxy_protocol_version' $CONFIG_PATH)

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

echo Verify frpc configuration

exec $FRP_PATH/frpc -c verify $FRPC_CONF < /dev/null

echo Start frp as client

exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null
