.PHONY: help
.PHONY: build-rosetta-testnet build-rosetta-mainnet
.PHONY: run-rosetta-mainnet-local run-rosetta-testnet-local
.PHONY: run-rosetta-mainnet-remote run-rosetta-testnet-remote
.PHONY: build-geth-testnet build-geth-mainnet
.PHONY: run-geth-testnet run-geth-mainnet

PWD=$(shell pwd)
NOFILE=100000

PLATFORM_FLAG :=
DOCKER_API_VERSION := $(shell docker version --format '{{.Server.APIVersion}}')
ifeq ($(shell expr $(DOCKER_API_VERSION) \>= 1.41), 1)
	PLATFORM_FLAG := --platform linux/amd64
endif


define check_build_params
	@if [ -z "$(CORE_CHAIN_VERSION)" ]; then \
		echo "This target requires CORE_CHAIN_VERSION to be defined"; \
		echo ""; \
		echo "Usage: make build-$1 CORE_CHAIN_VERSION=<core-chain version>"; \
		echo ""; \
		exit 1; \
	fi
endef

define check_local_mode_params
	@if [ "$(FROM_SCRATCH)" != "true" ] && [ "$(FROM_SCRATCH)" != "false" ]; then \
		echo "This target requires FROM_SCRATCH to be defined"; \
		echo "";\
		echo "Usage: make run-$1 FROM_SCRATCH=<true/false> SNAPSHOT_URL=<url>"; \
		echo "  	FROM_SCRATCH=true  - Download geth data snapshot from SNAPSHOT_URL and start geth node based on the snapshot"; \
		echo "  	FROM_SCRATCH=false - Start geth node based on the current data directory"; \
		echo ""; \
		exit 1; \
	fi
	@if [ "$(FROM_SCRATCH)" = "true" ] && [ -z "$(SNAPSHOT_URL)" ]; then \
		echo "SNAPSHOT_URL is not defined"; \
		exit 1; \
	fi
endef

define check_remote_mode_params
	@if [ -z "$(GETH)" ]; then \
		echo "This target requires GETH to be defined"; \
		echo "";\
		echo "Usage: make run-$1 GETH=<geth rpc node url>"; \
		echo ""; \
		exit 1; \
	fi
endef

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo " Avaliable targets:"
	@echo "		build-rosetta-testnet 		Build the testnet rosetta-core image"
	@echo "		build-rosetta-mainnet 		Build the mainnet rosetta-core image"
	@echo "		run-rosetta-testnet-local	Run the testnet rosetta-core image in online mode based on the local geth node"
	@echo "		run-rosetta-mainnet-local 	Run the mainnet rosetta-core image in online mode based on the local geth node"
	@echo "		run-rosetta-testnet-remote 	Run the testnet rosetta-core image in online mode based on the remote geth node"
	@echo "		run-rosetta-mainnet-remote 	Run the mainnet rosetta-core image in online mode based on the remote geth node"
	@echo "		build-geth-testnet 			Build the testnet core-chain image"
	@echo "		build-geth-mainnet 			Build the mainnet core-chain image"
	@echo "		run-geth-testnet			Run the testnet core-chain image"
	@echo "		run-geth-mainnet 			Run the mainnet core-chain image"


#
# The following targets are related to rosetta-core
#
build-rosetta-testnet:
	$(call check_build_params,rosetta-testnet)
	docker build ${PLATFORM_FLAG} --build-arg CORE_CHAIN_VERSION=$(CORE_CHAIN_VERSION) -t rosetta-core:testnet-latest -f Dockerfile.rosetta .

build-rosetta-mainnet:
	$(call check_build_params,rosetta-mainnet)
	docker build ${PLATFORM_FLAG} --build-arg CORE_CHAIN_VERSION=$(CORE_CHAIN_VERSION) -t rosetta-core:mainnet-latest -f Dockerfile.rosetta .

run-rosetta-testnet-local:
	$(call check_local_mode_params,rosetta-testnet-local)
	mkdir -p core-testnet-data && docker run --name rosetta-core-testnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-testnet-data:/data" -e "MODE=ONLINE" -e "NETWORK=BUFFALO" -e "PORT=8080" -e "FROM_SCRATCH=$(FROM_SCRATCH)" -e "SNAPSHOT_URL=$(SNAPSHOT_URL)" -p 8080:8080 -p 35012:35012 -p 8575:8575 rosetta-core:testnet-latest

run-rosetta-mainnet-local:
	$(call check_local_mode_params,rosetta-mainnet-local)
	mkdir -p core-mainnet-data && docker run --name rosetta-core-mainnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-mainnet-data:/data" -e "MODE=ONLINE" -e "NETWORK=CORE" -e "PORT=8080" -e "FROM_SCRATCH=$(FROM_SCRATCH)" -e "SNAPSHOT_URL=$(SNAPSHOT_URL)" -p 8080:8080 -p 35021:35021 -p 8579:8579 rosetta-core:mainnet-latest

run-rosetta-testnet-remote:
	$(call check_remote_mode_params,rosetta-testnet-remote)
	docker run --name rosetta-core-testnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -e "MODE=ONLINE" -e "NETWORK=BUFFALO" -e "PORT=8080" -e "GETH=$(GETH)" -p 8080:8080  rosetta-core:testnet-latest

run-rosetta-mainnet-remote:
	$(call check_remote_mode_params,rosetta-mainnet-remote)
	docker run --name rosetta-core-mainnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -e "MODE=ONLINE" -e "NETWORK=CORE" -e "PORT=8080" -e "GETH=$(GETH)" -p 8080:8080  rosetta-core:mainnet-latest


#
# The following targets are related to core-chain node
#
build-geth-testnet:
	$(call check_build_params,geth-testnet)
	docker build ${PLATFORM_FLAG} --build-arg CORE_CHAIN_VERSION=$(CORE_CHAIN_VERSION) -t core-chain:testnet-latest -f Dockerfile.geth .


build-geth-mainnet:
	$(call check_build_params,geth-mainnet)
	docker build ${PLATFORM_FLAG} --build-arg CORE_CHAIN_VERSION=$(CORE_CHAIN_VERSION) -t core-chain:mainnet-latest -f Dockerfile.geth .

run-geth-testnet:
	$(call check_local_mode_params,geth-testnet)
	mkdir -p core-testnet-data && docker run --name core-chain-testnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-testnet-data:/data" -e "NETWORK=BUFFALO" -e "FROM_SCRATCH=$(FROM_SCRATCH)" -e "SNAPSHOT_URL=$(SNAPSHOT_URL)" -p 35012:35012 -p 8575:8575 core-chain:testnet-latest

run-geth-mainnet:
	$(call check_local_mode_params,geth-mainnet)
	mkdir -p core-mainnet-data && docker run --name core-chain-mainnet -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-mainnet-data:/data" -e "NETWORK=CORE" -e "FROM_SCRATCH=$(FROM_SCRATCH)" -e "SNAPSHOT_URL=$(SNAPSHOT_URL)" -p 35021:35021 -p 8579:8579 core-chain:mainnet-latest
