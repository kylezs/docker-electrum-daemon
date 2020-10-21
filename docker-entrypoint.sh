#!/usr/bin/env bash
set -ex

# Graceful shutdown
trap 'pkill -TERM -P1; electrum daemon stop; exit 0' SIGTERM

# Testnet support
if [ "$TESTNET" = true ]; then
  FLAGS='--testnet'
fi

# Run application
electrum daemon -d --testnet

# get some info, test if daemon is up
electrum getinfo --testnet

# Set config
electrum setconfig rpcuser ${ELECTRUM_USER} --testnet
electrum setconfig rpcpassword ${ELECTRUM_PASSWORD} --testnet
electrum setconfig rpchost 0.0.0.0 --testnet
electrum setconfig rpcport 7777 --testnet

# XXX: Check load wallet or create

echo "tried to start daemon"

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
