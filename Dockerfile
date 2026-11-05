# OnlyJah's shared Caddy image. Projects don't deploy this repo directly:
# each one builds FROM the published image and copies in its own Caddyfile
# from a gateway/ folder in its own repo (see README).
ARG CADDY_RELEASE=2.11.9

# The builder image only provides Go and xcaddy (the pinned -builder tags
# are Windows-only on Docker Hub); xcaddy builds the Caddy version set here.
FROM caddy:2-builder AS builder
ARG CADDY_RELEASE
ENV CADDY_VERSION=v${CADDY_RELEASE}

# Space-, comma- or newline-separated Go module paths of Caddy plugins.
ARG CADDY_PLUGINS=

COPY --chmod=755 build.sh /build.sh
RUN sh /build.sh

FROM caddy:${CADDY_RELEASE}-alpine

COPY --from=builder /usr/local/bin/caddy-custom /usr/bin/caddy
# Fallback page and config, replaced by each project's gateway/Caddyfile.
COPY ./www /www
COPY ./Caddyfile /etc/caddy/Caddyfile
