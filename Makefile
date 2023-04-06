### Defensive settings for make:
#     https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
.SHELLFLAGS:=-xeu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules
MAKEFLAGS+=--output-sync=target

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Project Name
PROJECT_NAME=plone-nl
# Folder containing this Makefile
PROJECT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Versions
PLONE_VERSION=$$(cat $(PROJECT_DIR)/backend/version.txt)
VOLTO_VERSION=$$(cat $(PROJECT_DIR)/frontend/version.txt)
PROJECT_VERSION=$$(cat version.txt)


# Get current user information
CURRENT_USER=$$(whoami)
USER_INFO=$$(python -c 'import os,grp,pwd;uid=os.getuid();user=pwd.getpwuid(uid);guid=user.pw_gid;print(f"{uid}:{guid}")')
# Compose files used in local development
DEV_COMPOSE=docker-compose.yml
DEV_COMPOSE_OVERRIDE=override.yml
ACCEPTANCE_COMPOSE=devops/dev/acceptance.yml


COMPOSE_CMD=PROJECT_DIR=${PROJECT_DIR} VOLTO_VERSION=${VOLTO_VERSION} PLONE_VERSION=${PLONE_VERSION} USER=${USER_INFO} docker compose

ifneq ("$(wildcard $(DEV_COMPOSE_OVERRIDE))","")
		DEV_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME} -f ${DEV_COMPOSE} -f ${DEV_COMPOSE_OVERRIDE}
else
		DEV_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME} -f ${DEV_COMPOSE}
endif
#DEV_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME} -f ${DEV_COMPOSE} -f ${DEV_COMPOSE_OVERRIDE}

ACCEPTANCE_CMD=${COMPOSE_CMD} -p ${PROJECT_NAME}-acceptance -f ${ACCEPTANCE_COMPOSE}

# Service Names
SERVICE_BACKEND=backend-dev
SERVICE_FRONTEND=frontend-dev

# Container Names
CONTAINER_BACKEND=${PROJECT_NAME}-${SERVICE_BACKEND}-1
CONTAINER_FRONTEND=${PROJECT_NAME}-${SERVICE_FRONTEND}-1

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
	${DEV_CMD} build ${SERVICE_FRONTEND}

.PHONY: install-frontend-clean
install-frontend-clean:  ## Install React Frontend
	$(MAKE) -C "./frontend/" config
	${DEV_CMD} build ${SERVICE_FRONTEND} --no-cache

.PHONY: debug-frontend
debug-frontend:  ## Run bash in the Frontend container
	${DEV_CMD} run --rm --entrypoint bash ${SERVICE_FRONTEND} || true

.PHONY: stop-frontend
stop-frontend:  ## Stop Frontend
	${DEV_CMD} stop ${SERVICE_FRONTEND}

.PHONY: start-frontend-daemon
start-frontend-daemon:  ## Start Frontend as daemon
	${DEV_CMD} up -d ${SERVICE_FRONTEND}

.PHONY: start-frontend
start-frontend:  start-frontend-daemon ## Start React Frontend
	@echo -e "\nStarting frontend only. Don't forget to run the backend separately"
	@docker attach ${CONTAINER_FRONTEND}

.PHONY: install-backend
install-backend:  ## Build development image for Backend
	${DEV_CMD} build ${SERVICE_BACKEND}

.PHONY: install-backend-clean
install-backend-clean:  ## Build development image for Backend
	${DEV_CMD} build ${SERVICE_BACKEND} --no-cache

.PHONY: debug-backend
debug-backend:  ## Run bash in the Frontend container
	${DEV_CMD} run --rm --entrypoint bash ${SERVICE_BACKEND} || true

.PHONY: stop-backend
stop-backend:  ## Stop Frontend
	${DEV_CMD} stop ${SERVICE_BACKEND}

.PHONY: start-backend-daemon
start-backend-daemon:  ## Start Plone Backend as daemon
	${DEV_CMD} up -d ${SERVICE_BACKEND}

.PHONY: start-backend
start-backend:  start-backend-daemon ## Start Plone Backend
	@echo -e "\nStarting backend only. Don't forget to run the frontend separately"
	@docker attach ${CONTAINER_BACKEND}

.PHONY: compose-down
compose-down-clean:  ## Build development image for Backend
	${DEV_CMD} down --remove-orphans


.PHONY: status
status:  ## Status of the stack
	@echo -e "\nCommand line for docker-compose to append custom commands:\n${DEV_CMD}\n"
	${DEV_CMD} ps

.PHONY: install
install:  ## Setup containers for backend and frontend
	@echo "Install Backend & Frontend"
	$(MAKE) install-backend
	$(MAKE) install-frontend

.PHONY: start
start:  ## Start Backend and Frontend
	@echo "Start Backend & Frontend for development:"
	${DEV_CMD} up || true

# Code Linting & Formatting
.PHONY: format-backend
format-backend:  ## Format Backend Codebase
	@echo "Format backend codebase"
	$(MAKE) -C "./backend/" format

.PHONY: format-frontend
format-frontend:  ## Format Frontend Codebase
	@echo "Format frontend codebase"
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} lint:fix
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} prettier:fix
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} stylelint:fix

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
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} lint
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} prettier
#	${DEV_CMD} run --rm ${SERVICE_FRONTEND} stylelint

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
	${DEV_CMD} run --rm ${SERVICE_BACKEND} /app/bin/pytest src/ploneconf.core/tests

.PHONY: test-frontend
test-frontend:  ## Test frontend codebase
	@echo "Test frontend"
	${DEV_CMD} run --rm ${SERVICE_FRONTEND} test --watchAll

.PHONY: test-frontend-ci
test-frontend-ci:  ## Test frontend codebase once
	@echo "Test frontend"
	${DEV_CMD} run --rm -e CI=1 ${SERVICE_FRONTEND} test

.PHONY: test
test:  test-backend test-frontend-ci ## Test codebase

# Build container images

.PHONY: build-image-frontend
build-image-frontend:
	@echo "Build Frontend image"
	$(MAKE) -C "./frontend/" build-image

.PHONY: build-image-backend
build-image-backend:
	@echo "Build Backend image"
	$(MAKE) -C "./backend/" build-image

.PHONY: build-images
build-images: build-image-frontend build-image-backend

.PHONY: create-tag
create-tag: # Create a new tag using git
	@echo "Creating new tag $(PROJECT_VERSION)"
	if git show-ref --tags v$(PROJECT_VERSION) --quiet; then echo "$(PROJECT_VERSION) already exists";else git tag -a v$(PROJECT_VERSION) -m "Release $(PROJECT_VERSION)" && git push && git push --tags;fi

.PHONY: commit-and-release
commit-and-release: # Commit new version change and create tag
	@echo "Commiting changes"
	@git commit -am "Tag release as $(PROJECT_VERSION) to deploy"
	make create-tag

.PHONY: write-dot-env
write-dot-env:
	@echo "Writing .env file"
	@echo "VOLTO_VERSION=$(VOLTO_VERSION)" > $(PROJECT_DIR)/.env
	@echo "PLONE_VERSION=$(PLONE_VERSION)" >> $(PROJECT_DIR)/.env
	@echo "USER=$(USER_INFO)" >> $(PROJECT_DIR)/.env
	@echo "COMPOSE_PROJECT_NAME=$(PROJECT_NAME)" >> $(PROJECT_DIR)/.env
	@echo "PROJECT_DIR=$(PROJECT_DIR)" >> $(PROJECT_DIR)/.env
