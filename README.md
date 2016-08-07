# api-abilitysheet

## Usage

```
$ shards
$ cp .env.circleci .env # your setting
$ crystal build --release src/app.cr
$ foreman start
```

## Requirements

- crystal 0.18.7
- postgresql 9.5.1

## nginx

```
upstream crystal {
  server localhost:8080;
  keepalive 300;
}

server {
  location /api {
    access_log off;
    error_log /dev/null crit;
    add_header Access-Control-Allow-Origin *;
    proxy_pass http://crystal;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
  }
}
```
