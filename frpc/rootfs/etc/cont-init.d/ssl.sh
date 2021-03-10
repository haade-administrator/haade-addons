#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

FRP_PATH_SSL=$FRP_PATH/ssl
FRPC_CONF=$FRP_PATH/frpc.ini
FRPC_CONF_CERT=$FRP_PATH_SSL/fullchain.pem
FRPC_CONF_KEY=$FRP_PATH_SSL/privkey.pem

chmod 600 /var/frp/ssl/fullchain.pem
chmod 600 /var/frp/ssl/privkey.pem
cp "$FRPC_CONF_CERT" "/ssl/"
cp "$FRPC_CONF_KEY" "/ssl/"

echo transfert certificat
