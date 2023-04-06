# plone.nl

Plone Nederland Site

## Quick start

### Development Setup

- Python 3.11
- Node 16
- yarn
- Docker

### Install

```shell
git clone git@github.com:plone/plone.nl.git
cd plone.nl
make install
```

### Start

Start the Backend (http://localhost:8080/)

```shell
make start-backend
```

Start the Frontend (http://localhost:3000/)

```shell
make start-frontend
```

## Structure
This mono repo is composed of two distinct codebases: Backend and Frontend.

- **backend**: API (Backend) Plone installation using pip (not buildout). Includes a policy package named ploneconf.core
- **frontend**: React (Volto) package named frontend

## Linters and Formatting

There are some hooks to run lint checks on the code. If you want to automatically format them, in the root of this repository, run

```shell
make format
```

Linters commands are available in each backend and frontend folder.

```shell
make lint
```

## Acceptance tests

There are `Makefile` commands in place:

`build-test-acceptance-server`: Build Acceptance Backend Server Docker image that it's being used afterwards. Must be run before running the tests, if the backend code has changed.

`start-test-acceptance-server`: Start server fixture in docker (previous build required)

`start-test-acceptance-frontend`: Start the Core Acceptance Frontend Fixture in dev mode

`test-acceptance`: Start Core Cypress Acceptance Tests in dev mode
