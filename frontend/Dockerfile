# syntax=docker/dockerfile:1
FROM node:16-slim as base
FROM base as builder

RUN <<EOT
    apt-get update
    buildDeps="python3 build-essential git ca-certificates"
    apt-get install -y --no-install-recommends $buildDeps
    rm -rf /var/lib/apt/lists/*
EOT

COPY --chown=node . /build/
RUN corepack enable

USER node
WORKDIR /build
RUN <<EOT
    make install
    yarn build
EOT

FROM base

LABEL maintainer="Plone Foundation <conf@plone.org>" \
      org.label-schema.name="ploneconf-frontend" \
      org.label-schema.description="Plone Conference 2023 frontend." \
      org.label-schema.vendor="Plone Foundation" \
      org.label-schema.docker.cmd="docker run -d -p 3000:3000 plone/ploneconf-frontend:latest"

RUN <<EOT
    apt-get update
    buildDeps="busybox"
    apt-get install -y --no-install-recommends $buildDeps
    busybox --install -s
    rm -rf /var/lib/apt/lists/*
EOT

USER node
COPY --from=builder /build/ /app/

WORKDIR /app
EXPOSE 3000
CMD ["yarn", "start:prod"]
