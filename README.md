# docker-rosetta-core
## Build Rosetta-Core Image
**Building the image requires the correct [core-chain version](https://github.com/coredao-org/core-chain/releases). We recommend using the [latest version](https://github.com/coredao-org/core-chain/releases/latest).**

### Testnet
    make build-rosetta-testnet CORE_CHAIN_VERSION=<core-chain verison>

### Mainnet
    make build-rosetta-mainnet CORE_CHAIN_VERSION=<core-chain verison>

## Run Rosetta-Core
**If you want to speed up the Core node syncing process, it is recommended to run it from a [snapshot](https://github.com/coredao-org/core-snapshots/tree/main). Note it might still take a few hours to download the snapshot and extract the data from it.**

Rosetta-core can run in two modes: local mode and remote mode.

In local mode, the core-chain node is started by rosetta-core itself.

In remote mode, the core-chain node is started independently, and rosetta-core connects to this node next.

### Local Mode
#### Testnet
##### Run based on snapshot:
    make run-rosetta-testnet-local FROM_SCRATCH=true SNAPSHOT_URL=<testnet snapshot url>

##### Run based on current data:
    make run-rosetta-testnet-local FROM_SCRATCH=false

#### Mainnet
##### Run based on snapshot:
    make run-rosetta-mainnet-local FROM_SCRATCH=true SNAPSHOT_URL=<mainnet snapshot url>

##### Run based on current data:
    make run-rosetta-mainnet-local FROM_SCRATCH=false


### Remote Mode
Before running rosetta-core in remote mode, you need to run a core-chain node independently.

#### Build Core-Chain Image
##### Testnet
    make build-geth-testnet CORE_CHAIN_VERSION=<core-chain verison>

##### Mainnet
    make build-geth-mainnet CORE_CHAIN_VERSION=<core-chain verison>


#### Run Core-Chain Node
##### Testnet
###### Run based on snapshot:
    make run-geth-testnet FROM_SCRATCH=true SNAPSHOT_URL=<testnet snapshot url>

###### Run based on current data:
    make run-geth-testnet FROM_SCRATCH=false

##### Mainnet
###### Run based on snapshot:
    make run-geth-mainnet FROM_SCRATCH=true SNAPSHOT_URL=<mainnet snapshot url>

###### Run based on current data:
    make run-geth-mainnet FROM_SCRATCH=false

#### Run Rosetta-Core
If the core-chain node is running in a Docker container on the same box as of Rosetta, you can use the command `docker inspect "<geth container id>" | jq -r .[0].NetworkSettings.Networks[].Gateway` to obtain the node's IP address. The default HTTP port for the core-chain testnet node is 8575, and for the mainnet node is 8579.

##### Testnet
    make run-rosetta-testnet-remote GETH=http://<IP>:8575

##### Mainnet
    make run-rosetta-mainnet-remote GETH=http://<IP>:8579
