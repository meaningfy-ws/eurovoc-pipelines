SHELL=/bin/bash -o pipefail
BUILD_PRINT = \e[1;34mSTEP:
END_BUILD_PRINT = \e[0m

CURRENT_UID := $(shell id -u)
export CURRENT_UID
# These are constants used for make targets so we can start prod and staging services on the same machine
ENV_FILE := .env

# include .env files if they exist
-include .env

PROJECT_PATH = $(shell pwd)
ETL_STORAGE_FOLDER ?= ${PROJECT_PATH}/ etl-storage


#-----------------------------------------------------------------------------
# VAULT SERVICES
#-----------------------------------------------------------------------------
# Testing whether an env variable is set or not
guard-%:
	@ if [ "${${*}}" = "" ]; then \
        echo -e "$(BUILD_PRINT)Environment variable $* not set $(END_BUILD_PRINT)"; \
        exit 1; \
	fi

# Testing that vault is installed
vault-installed: #; @which vault1 > /dev/null
	@ if ! hash vault 2>/dev/null; then \
        echo -e "$(BUILD_PRINT)Vault is not installed, refer to https://www.vaultproject.io/downloads $(END_BUILD_PRINT)"; \
        exit 1; \
	fi
# Get secrets in dotenv format
dotenv-file: guard-VAULT_ADDR guard-VAULT_TOKEN vault-installed
	@ echo -e "$(BUILD_PRINT)Creating .env.staging file $(END_BUILD_PRINT)"
	@ echo VAULT_ADDR=${VAULT_ADDR} > .env
	@ echo VAULT_TOKEN=${VAULT_TOKEN} >> .env
	@ echo DOMAIN=meaningfy.ws >> .env
	@ echo SUBDOMAIN=etl. >> .env

build-externals:
	@ echo -e "$(BUILD_PRINT)Creating the necessary volumes, networks and folders and setting the special rights"
	@ docker network create proxy-net || true
	@ docker network create linked-pipes || true

start-linkedpipes: build-externals
	@ echo -e "$(BUILD_PRINT)Starting LinkedPipes service $(END_BUILD_PRINT)"
	@ docker-compose -p common --file infra/linkedpipes/docker-compose.yml --env-file ${ENV_FILE} up -d

stopt-linkedpipes:
	@ echo -e "$(BUILD_PRINT)Stopping LinkedPipes service $(END_BUILD_PRINT)"
	@ docker-compose -p common --file infra/linkedpipes/docker-compose.yml --env-file ${ENV_FILE} down

start-graphdb: build-externals
	@ echo -e "$(BUILD_PRINT)Starting the GraphDB services $(END_BUILD_PRINT)"
	@ docker-compose -p ${ENVIRONMENT} --file ./infra/graphdb/docker-compose.yml --env-file ${ENV_FILE} up -d

stop-graphdb:
	@ echo -e "$(BUILD_PRINT)Stopping the GraphDB services $(END_BUILD_PRINT)"
	@ docker-compose -p ${ENVIRONMENT} --file ./infra/graphdb/docker-compose.yml --env-file ${ENV_FILE} down