FROM golang:1.16-alpine as builder

ENV GOPATH /go
COPY ./src /src
WORKDIR /src

RUN set -xe \
    && apk add --no-cache git musl-dev gcc \
    && /usr/local/go/bin/go mod init caddy \
    && /usr/local/go/bin/go get -d -v github.com/caddyserver/caddy/v2@v2.4.0 \
    && /usr/local/go/bin/go build -o /${GOPATH}/caddy -ldflags -w -trimpath \
    && "${GOPATH}/caddy" version

FROM alpine:3.13

LABEL description="caddy v2 server" maintainer="github@compuix.com" version="2021.05.14"

RUN apk --no-cache add ca-certificates \
    && mkdir -p /caddy/config/caddy /caddy/data/caddy /etc/caddy

COPY --from=builder /go/caddy /usr/bin/caddy
COPY index.html /www/index.html

ENV XDG_CONFIG_HOME=/caddy/config
ENV XDG_DATA_HOME=/caddy/data

VOLUME /caddy

EXPOSE 80 443

CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
