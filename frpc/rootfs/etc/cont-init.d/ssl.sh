chmod 600 /var/frp/ssl/fullchain.pem
chmod 600 /var/frp/ssl/privkey.pem
cp "$FRPC_CONF_CERT" "/ssl/"
cp "$FRPC_CONF_KEY" "/ssl/"
