FROM golang:1.22-alpine as builder

RUN set -xe \
    && apk add --no-cache git musl-dev gcc \
    && go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
    && xcaddy build v2.8.4 \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddyserver/transform-encoder \
    --output /usr/bin/caddy \
    && /usr/bin/caddy version \
    && /usr/bin/caddy build-info \
    && /usr/bin/caddy list-modules | grep -E "(webdav|transform)"

FROM alpine:3.21.0

LABEL \
    version="2024.09.20" \
    maintainer="github@compuix.com" \
    description="caddy v2 server"

RUN apk --no-cache add ca-certificates \
    && mkdir -p /caddy/config/caddy /caddy/data/caddy /etc/caddy

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY index.html /www/index.html

ENV XDG_CONFIG_HOME=/caddy/config
ENV XDG_DATA_HOME=/caddy/data

VOLUME /caddy

EXPOSE 80 443

CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
