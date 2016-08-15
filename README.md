# api-abilitysheet

## Usage

```
$ docker build -t abilitysheet .
$ cp .env.circleci .env # your setting
$ docker run -d -p 8080:8080 --name=api-abilitysheet abilitysheet
```

## Requirements

- postgresql 9.5.3
- docker 1.12.0

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
