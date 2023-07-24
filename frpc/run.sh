#!/usr/bin/with-contenv bashio
set -e

FRP_PATH=/var/frp
FRPC_CONF=$FRP_PATH/frpc.ini

if [ -f $FRPC_CONF ]; then
  rm $FRPC_CONF
fi

SERVER_ADDR=$(bashio::config 'server_addr')
SERVER_PORT=$(bashio::config 'server_port')
TOKEN_KEY=$(bashio::config 'token_key')
LOCAL_PORT=$(bashio::config 'local_port')

# Start the client (respawn if it terminates)
while true
do
  exec $FRP_PATH/frpc -c $FRPC_CONF < /dev/null &
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