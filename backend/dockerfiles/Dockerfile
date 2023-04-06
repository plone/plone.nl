# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.11
ARG PLONE_VERSION
FROM plone/server-builder:${PLONE_VERSION} as builder

WORKDIR /app

# Copy code and requirements
COPY requirements-prod.txt requirements.txt
COPY src src/
COPY scripts scripts/

# Copy additional zcml
COPY configure.zcml etc/package-includes/111-project-configure.zcml

# Install pip requirements
RUN --mount=type=cache,id=plonesite-pip,target=/root/.cache/pip <<EOT
    ./bin/pip install -r /app/requirements.txt
EOT

FROM plone/server-prod-config:${PLONE_VERSION}

LABEL maintainer="Plone Foundation <conf@plone.org>" \
      org.label-schema.name="plonesite-backend" \
      org.label-schema.description="Plone Site backend." \
      org.label-schema.vendor="Plone Foundation"

# Copy /app from builder
COPY --from=builder --chown=500:500 /app /app

RUN <<EOT
    ln -s /data /app/var
EOT
