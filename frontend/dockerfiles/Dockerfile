# syntax=docker/dockerfile:1
ARG VOLTO_VERSION
FROM plone/frontend-builder:${VOLTO_VERSION} as builder

# Copy jsconfig.json configuration
COPY --chown=node:node jsconfig.json /app/

# We copy here to install all addons (package.json)
COPY --chown=node:node src/addons/ /app/src/addons/

RUN <<EOT
    /setupAddon
    yarn install --network-timeout 1000000
    yarn build
    rm -rf cache omelette .yarn/cache
EOT

FROM plone/frontend-prod-config:${VOLTO_VERSION}

LABEL maintainer="kitconcept GmbH <server@kitconcept.com>" \
      org.label-schema.name="intra.kitconcept.com-frontend" \
      org.label-schema.description="kitconcept Intranet frontend image." \
      org.label-schema.vendor="kitconcept GmbH"

COPY --from=builder /app/ /app/
