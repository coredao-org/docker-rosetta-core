#!/bin/bash
set -euo pipefail

# Init local variables
HOME_DIR=/app
GETH_CONFIG_DIR=$HOME_DIR/configs
GETH_DATA_DIR=/data
: ${FROM_SCRATCH:=false}
: ${SNAPSHOT_URL:=}

# Init alias name of the network
if [[ "$NETWORK" = "CORE" ]]; then
    ALIAS_NETWORK="mainnet"
    CHAIN_ID=1116
elif [[ "$NETWORK" = "BUFFALO" ]]; then
    ALIAS_NETWORK="testnet"
    CHAIN_ID=1115
else
    echo "network $NETWORK is not recognized"
    exit 1
fi

# Print environment variables
echo "NETWORK       = $NETWORK"
echo "FROM_SCRATCH  = $FROM_SCRATCH"
echo "SNAPSHOT_URL  = $SNAPSHOT_URL"

# Ensure the root directory of the geth data exists
if [ ! -d "$GETH_DATA_DIR" ]; then
    echo "No $GETH_DATA_DIR volume attached"
    exit 1
fi

# Prepare the geth.toml
echo "prepare the config of $NETWORK, chain ID is $CHAIN_ID"
rm -f $GETH_CONFIG_DIR/geth.toml
cp $GETH_CONFIG_DIR/geth.toml.$ALIAS_NETWORK $GETH_CONFIG_DIR/geth.toml

# Download and decompress the snapshot
if [[ "$FROM_SCRATCH" = "true" ]]; then
    # Check `geth` directory is not exists
    if [ -d "$GETH_DATA_DIR/geth" ]; then
        echo "$GETH_DATA_DIR/geth is already exists"
        exit 1
    fi

    # Check snapshot url is not empty
    if [ -z "$SNAPSHOT_URL" ]; then
        echo "SNAPSHOT_URL is empty"
        exit 1
    fi

    # Check snapshot name
    SNAPSHOT_NAME=$(basename "$SNAPSHOT_URL")
    if [[ ! "$SNAPSHOT_NAME" =~ ^coredao-snapshot-${ALIAS_NETWORK}- ]]; then
        echo "SNAPSHOT_NAME $SNAPSHOT_NAME is invalid"
        exit 1
    fi

    # Start downloading
    echo "downloading snapshot $SNAPSHOT_NAME ..."
    if ! wget -t 0 -c $SNAPSHOT_URL 2>&1; then
        echo "Download failed, url is $SNAPSHOT_URL"
        exit 1
    fi
    echo "successfully downloaded the snapshot"

    # Check `geth` directory again
    if [ -d "$GETH_DATA_DIR/geth" ]; then
        echo "$GETH_DATA_DIR/geth is already exists"
        exit 1
    fi

    # Start decompressing
    echo "decompressing snapshot $SNAPSHOT_NAME ..."
    lz4 -d $SNAPSHOT_NAME | tar -xvf - -C $GETH_DATA_DIR
    echo "successfully decompressing the snapshot"
fi

# Check geth data directory
if [[ ! -d "$GETH_DATA_DIR/geth/chaindata" ]]; then
    echo "No $GETH_DATA_DIR/geth/chaindata"
    exit 1
fi

echo "start geth node"
exec $HOME_DIR/geth --config=$GETH_CONFIG_DIR/geth.toml --cache=8000 --gcmode=archive --graphql