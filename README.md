# docker-caddy2

Run [Caddy][1] v2 webserver inside a docker container.

## Usage

### Command line

Create directories:

```sh
mkdir www caddy-data
```

```sh
docker run -it --rm -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
  -v $(pwd)/caddy-data:/data -v $(pwd)/caddy-config:/config -v $(pwd)/www:/www sashk/docker-caddy2
```

### docker-compose

```yaml
version: "3"

services:
  caddy:
    image: sashk/docker-caddy2
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy2:/root/.caddy
      - ./path/to/www:/www
    ports:
     - "80:80"
     - "443:443"

volumes:
  caddy2:
```

[1]: https://github.com/caddyserver/caddy
