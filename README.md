# docker-rosetta-core
## Build Rosetta-Core Image
**Building the image requires the correct [core-chain version](https://github.com/coredao-org/core-chain/releases). We recommend using the latest version of core-chain.**

### Testnet
    make build-rosetta-testnet CORE_CHAIN_VERSION=<core-chain verison>

### Mainnet
    make build-rosetta-mainnet CORE_CHAIN_VERSION=<core-chain verison>



## Run Rosetta-Core
**Rosetta-core can run in two modes: local mode and remote mode.**

**In local mode, the core-chain node is started by rosetta-core itself.**

**In remote mode, the core-chain node is started independently, and rosetta-core connects to this node after startup**

### Local Mode
**When FROM_SCRATCH=true, it means running the geth node based on a snapshot, which requires the container to download snapshot file from the specified [SNAPSHOT_URL](https://github.com/coredao-org/core-snapshots) and extract it during startup. This process may take several hours to complete.**

**To expedite the initial synchronization progress of the node, we recommend using the snapshot.**


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
**Before running rosetta-core in remote mode, you need to run a core-chain node independently.**

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
**If the core-chain node is running in a Docker container on the current machine, you can use the command `docker inspect "<geth container id>" | jq -r .[0].NetworkSettings.Networks[].Gateway` to obtain the node's IP address. The default HTTP port for the core-chain testnet node is 8575, and for the mainnet node is 8579.**
##### Testnet

    make run-rosetta-testnet-remote GETH=http://<IP>:8575

##### Mainnet

    make run-rosetta-mainnet-remote GETH=http://<IP>:8579
