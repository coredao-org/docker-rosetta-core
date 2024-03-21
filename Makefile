.PHONY: build-testnet build-mainnet run-mainnet-online run-testnet-online run-mainnet-remote run-testnet-remote

PWD=$(shell pwd)
NOFILE=100000

PLATFORM_FLAG :=
DOCKER_API_VERSION := $(shell docker version --format '{{.Server.APIVersion}}')
ifeq ($(shell expr $(DOCKER_API_VERSION) \>= 1.41), 1)
	PLATFORM_FLAG := --platform linux/amd64
endif

build-testnet:
	docker build ${PLATFORM_FLAG} -t rosetta-core:testnet-latest -f Dockerfile.testnet .

build-mainnet:
	docker build ${PLATFORM_FLAG} -t rosetta-core:mainnet-latest -f Dockerfile.mainnet .

run-mainnet-online:
	docker run -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-mainnet-data:/data" -e "MODE=ONLINE" -e "NETWORK=CORE" -e "PORT=8080" -p 8080:8080 -p 35021:35021 -p 8579:8579 rosetta-core:mainnet-latest

run-testnet-online:
	docker run -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -v "${PWD}/core-testnet-data:/data" -e "MODE=ONLINE" -e "NETWORK=BUFFALO" -e "PORT=8080" -p 8080:8080 -p 35012:35012 -p 8575:8575 rosetta-core:testnet-latest

run-mainnet-remote:
	docker run -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -e "MODE=ONLINE" -e "NETWORK=CORE" -e "PORT=8080" -e "GETH=$(geth)" -p 8080:8080  rosetta-core:mainnet-latest

run-testnet-remote:
	docker run -d --rm ${PLATFORM_FLAG} --ulimit "nofile=${NOFILE}:${NOFILE}" -e "MODE=ONLINE" -e "NETWORK=BUFFALO" -e "PORT=8080" -e "GETH=$(geth)" -p 8080:8080  rosetta-core:testnet-latest