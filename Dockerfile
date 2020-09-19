FROM golang:1.15.2-alpine3.12 AS build-env

ENV HOME $GOPATH/src/github.com/8398a7/api-abilitysheet
WORKDIR $HOME

RUN \
  apk upgrade --no-cache && \
  apk add --update --no-cache git make

COPY go.mod go.sum $HOME/
RUN go mod download
COPY . $HOME
RUN make build

FROM alpine:3.12

ENV \
  HOME=/app \
  GIN_MODE=release
WORKDIR $HOME

COPY --from=build-env /go/src/github.com/8398a7/api-abilitysheet/bin/cmd /bin/api-abilitysheet
CMD /bin/api-abilitysheet start
