# api-abilitysheet

## Usage

```bash
$ dep ensure
$ go run main.go
```

or

```bash
$ docker build -t api-abilitysheet:latest .
$ docker run \
  -p 8080:8080 \
  -v $(pwd)/public:/app/public\
  -e DB_URL=postgres://user@docker.for.mac.host.internal:5432/db?sslmode=disable \
  --rm -it api-abilitysheet:latest
```

by Docker for Mac

## Requirements

- postgresql 10.4
- docker 18.06

## nginx

```nginx
upstream gin {
  server localhost:8080;
  keepalive 300;
}

server {
  location /api {
    access_log off;
    error_log /dev/null crit;
    add_header Access-Control-Allow-Origin *;
    proxy_pass http://gin;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
  }
}
```
