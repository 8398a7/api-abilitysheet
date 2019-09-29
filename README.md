# api-abilitysheet

## Usage

```bash
$ cp .envrc.tmpl .envrc # please setup db configuration
$ direnv allow
$ make vendor start
```

or

```bash
$ cp .envrc.tmpl .envrc # please setup db configuration
$ direnv allow
$ make build-image start-image
```

by Docker for Mac

## Requirements

- postgresql 11.5
- docker 19.03.2

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
