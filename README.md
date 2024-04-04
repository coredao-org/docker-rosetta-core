# docker-rosetta-core
## Build Docker Image
**Building the image requires the correct [core-chain version](https://github.com/coredao-org/core-chain/releases).We recommend using the latest version of core-chain.**

### Testnet
    make build-testnet CORE_CHAIN_VERSION=<core-chain verison>

### Mainnet
    make build-mainnet CORE_CHAIN_VERSION=<core-chain verison>

## Run Rosetta-Core in Docker
**When FROM_SCRATCH=true, it means running the geth node based on a snapshot, which requires the container to download snapshot file from the specified [SNAPSHOT_URL](https://github.com/coredao-org/core-snapshots) and extract it during startup. This process may take several hours to complete.**

**To expedite the initial synchronization progress of the node, we recommend using the snapshot.**


### Testnet
##### Run based on snapshot:
    make run-testnet-local FROM_SCRATCH=true SNAPSHOT_URL=<testnet snapshot url>

##### Run based on current data:
    make run-testnet-local FROM_SCRATCH=false

### Mainnet
##### Run based on snapshot:
    make run-mainnet-local FROM_SCRATCH=true SNAPSHOT_URL=<mainnet snapshot url>

##### Run based on current data:
    make run-mainnet-local FROM_SCRATCH=false