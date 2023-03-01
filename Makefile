### Defensive settings for make:
#     https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
.SHELLFLAGS:=-xeu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Project Name
PROJECT_NAME=2023-ploneconf

# Folder containing this Makefile
PROJECT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Versions
PLONE_VERSION=$$(cat ${PROJECT_DIR}/backend/version.txt)
VOLTO_VERSION=$$(cat ${PROJECT_DIR}/frontend/version.txt)


# Get current user information
CURRENT_USER=$$(whoami)
USER_INFO=$$(python -c 'import os,grp,pwd;uid=os.getuid();user=pwd.getpwuid(uid);guid=user.pw_gid;print(f"{uid}:{guid}")')

# Compose files used in local development
DEV_COMPOSE=devops/dev/local-dev.yml
ACCEPTANCE_COMPOSE=devops/dev/acceptance.yml

COMPOSE_CMD=PROJECT_DIR=${PROJECT_DIR} VOLTO_VERSION=${VOLTO_VERSION} PLONE_VERSION=${PLONE_VERSION} USER=${USER_INFO} docker compose
DEV_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME} -f ${DEV_COMPOSE}
ACCEPTANCE_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME}-acceptance -f ${ACCEPTANCE_COMPOSE}

# Container names
CONTAINER_BACKEND=backend-dev
CONTAINER_FRONTEND=frontend-dev

.PHONY: all
all: install

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help: ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: info
info: ## Debug information about this project
	@echo ""
	@echo "========================="
	@echo "Project Information"
	@echo "========================="
	@echo "- Project Name: ${PROJECT_NAME}"
	@echo "- Project Directory: ${PROJECT_DIR}"
	@echo "- Plone Version: ${PLONE_VERSION}"
	@echo "- Volto Version: ${VOLTO_VERSION}"
	@echo ""

.PHONY: install-frontend
install-frontend:  ## Install React Frontend
	$(MAKE) -C "./frontend/" config
	${DEV_CMD} build ${CONTAINER_FRONTEND}

.PHONY: debug-frontend
debug-frontend:  ## Run bash in the Frontend container
	${DEV_CMD} run --entrypoint bash ${CONTAINER_FRONTEND}

.PHONY: start-frontend
start-frontend:  ## Start React Frontend
	${DEV_CMD} up ${CONTAINER_FRONTEND}

.PHONY: install-backend
install-backend:  ## Build development image for Backend
	${DEV_CMD} build ${CONTAINER_BACKEND}

.PHONY: start-backend
start-backend:  ## Start Plone Backend
	${DEV_CMD} up ${CONTAINER_BACKEND}

.PHONY: status
status:  ## Status of the stack
	${DEV_CMD} ps

.PHONY: install
install:  ## Setup containers for backend and frontend
	@echo "Install Backend & Frontend"
	$(MAKE) install-backend
	$(MAKE) install-frontend

.PHONY: start
start:  ## Start Backend and Frontend
	@echo "Start Backend & Frontend"
	$(MAKE) start-backend
	$(MAKE) start-frontend

# Code Linting & Formatting
.PHONY: format-backend
format-backend:  ## Format Backend Codebase
	@echo "Format backend codebase"
	$(MAKE) -C "./backend/" format

.PHONY: format-frontend
format-frontend:  ## Format Frontend Codebase
	@echo "Format frontend codebase"
	${DEV_CMD} run ${CONTAINER_FRONTEND} lint:fix
	${DEV_CMD} run ${CONTAINER_FRONTEND} prettier:fix
	${DEV_CMD} run ${CONTAINER_FRONTEND} stylelint:fix

.PHONY: format
format:  ## Format codebase
	@echo "Format codebase"
	$(MAKE) format-backend
	$(MAKE) format-frontend

.PHONY: lint-backend
lint-backend:  ## Lint Backend Codebase
	@echo "Lint backend codebase"
	$(MAKE) -C "./backend/" lint

.PHONY: lint-frontend
lint-frontend:  ## Lint Frontend Codebase
	@echo "Lint frontend codebase"
	${DEV_CMD} run ${CONTAINER_FRONTEND} lint
	${DEV_CMD} run ${CONTAINER_FRONTEND} prettier
	${DEV_CMD} run ${CONTAINER_FRONTEND} stylelint

.PHONY: lint
lint:  ## Lint codebase
	@echo "Format codebase"
	$(MAKE) format-backend
	$(MAKE) format-frontend

# .PHONY: i18n
# i18n:  ## Update locales
# 	@echo "Update locales"
# 	$(MAKE) -C "./backend/" i18n
# 	$(MAKE) -C "./frontend/" i18n

# Tests
.PHONY: test-backend
test-backend:  ## Test backend codebase
	@echo "Test backend"
	${DEV_CMD} run ${CONTAINER_BACKEND} /app/bin/pytest src/ploneconf.core/tests

.PHONY: test-frontend
test-frontend:  ## Test frontend codebase
	@echo "Test frontend"
	${DEV_CMD} run ${CONTAINER_FRONTEND} test --watchAll

.PHONY: test-frontend-ci
test-frontend-ci:  ## Test frontend codebase once
	@echo "Test frontend"
	${DEV_CMD} run -e CI=1 ${CONTAINER_FRONTEND} test

.PHONY: test
test:  test-backend test-frontend-ci ## Test codebase

# Build container images
.PHONY: build-images
build-images:  ## Build docker images
	@echo "Build"
	$(MAKE) -C "./backend/" build-image
	$(MAKE) -C "./frontend/" build-image
