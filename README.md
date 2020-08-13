# docker-caddy2

Run [Caddy][1] v2 webserver inside a docker container.

## Usage

### Command line

Create directories:

```sh
mkdir www caddy
```

```sh
docker run -it --rm -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
  -v $(pwd)/caddy:/caddy -v $(pwd)/www:/www docker.pkg.github.com/sashkab/docker-caddy2/docker-caddy2:latest
```

### docker-compose

```yaml
version: "3"

services:
  caddy:
    image: docker.pkg.github.com/sashkab/docker-caddy2/docker-caddy2:latest
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy2:/caddy
      - ./path/to/www:/www
    ports:
     - "80:80"
     - "443:443"

volumes:
  caddy2:
```

[1]: https://github.com/caddyserver/caddy
