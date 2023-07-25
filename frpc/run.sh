#!/usr/bin/with-contenv bashio
set -e

FRPC=/app/frpc
FRPC_CONF=/app/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

SERVER_ADDR=$(bashio::config 'server_addr')
SERVER_PORT=$(bashio::config 'server_port')
TOKEN_KEY=$(bashio::config 'token_key')
LOCAL_PORT=$(bashio::config 'local_port')

# Create ini-file
echo "[common]" >> $FRPC_CONF
echo "server_addr = $SERVER_ADDR" >> $FRPC_CONF
echo "server_port = $SERVER_PORT" >> $FRPC_CONF
echo "protocol = tcp" >>  $FRPC_CONF
echo "token = $TOKEN_KEY" >> $FRPC_CONF
echo "tls_enable = true" >> $FRPC_CONF
echo "[homeassistant]" >> $FRPC_CONF
echo "type = tcp" >> $FRPC_CONF
echo "local_ip = 127.0.0.1" >> $FRPC_CONF
echo "local_port = $LOCAL_PORT" >> $FRPC_CONF
echo "use_encryption = true" >> $FRPC_CONF
echo "use_compression = true" >> $FRPC_CONF

# Start the client (respawn if it terminates)
while true
do
  exec $FRPC -c $FRPC_CONF < /dev/null &
  PID=$!
  bashio::log.info "Launched new frps-PID ${PID}"

  while true
  do
    $(kill -0 ${PID} &> /dev/null) || break
    sleep 5
  done

  bashio::log.info "${PID} has terminated."
  sleep 5s
done