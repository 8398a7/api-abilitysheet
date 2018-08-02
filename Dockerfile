FROM golang:1.10.3-alpine3.8 AS build-env

ENV HOME $GOPATH/src/github.com/8398a7/api-abilitysheet
WORKDIR $HOME

RUN \
  apk upgrade --no-cache && \
  apk add --update --no-cache git
RUN go get -u github.com/golang/dep/cmd/dep

COPY . $HOME
RUN dep ensure
RUN go build main.go

FROM alpine:3.8

ENV \
  HOME=/app \
  GIN_MODE=release
WORKDIR $HOME

COPY --from=build-env /go/src/github.com/8398a7/api-abilitysheet/main $HOME/main
CMD $HOME/main
