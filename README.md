# docker-rosetta-core
## Download Archive node snapshot
### Testnet
wget -t 0 -c -b https://snap.coredao.org/coredao-snapshot-testnet-20240321.tar.lz4

### Mainnet
wget -t 0 -c -b https://snap.coredao.org/coredao-snapshot-mainnet-20240321.tar.lz4

## Extract snapshot to Geth data directoy
### Testnet
The directory name `core-testnet-data` must be consistent with the -v parameter defined in the [`make run-testnet-online`](https://github.com/coredao-org/docker-rosetta-core/blob/main/Makefile#L22) command.
This directory will be mounted into the Docker container as the data directory for the Geth node.

mkdir core-testnet-data<br>
nohup sh -c "lz4 -d coredao-snapshot-testnet-20240321.tar.lz4 | tar -xvf - -C core-testnet-data" &> output.log &

### Mainnet
The directory name `core-mainnet-data` must be consistent with the -v parameter defined in the [`make run-mainnet-online`](https://github.com/coredao-org/docker-rosetta-core/blob/main/Makefile#L19) command.
This directory will be mounted into the Docker container as the data directory for the Geth node.

mkdir core-mainnet-data<br>
nohup sh -c "lz4 -d coredao-snapshot-mainnet-20240321.tar.lz4 | tar -xvf - -C core-mainnet-data" &> output.log &

## Build Docker Image
### Testnet
sudo make build-testnet

### Mainnet
sudo make build-mainnet

## Run Rosetta-Core in Docker
Ensure that the snapshot data is fully extracted into the Geth data directory before proceeding with the following instructions.

### Testnet
sudo make run-testnet-online

### Mainnet
sudo make run-mainnet-online
