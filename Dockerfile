#
# build
#
FROM golang:1.12-alpine AS build
RUN apk add --update --no-cache curl git make protobuf musl-dev protobuf-dev gcc

RUN \
  go get -d google.golang.org/protobuf/cmd/protoc-gen-go && \
  git -C "$(go env GOPATH)"/src/google.golang.org/protobuf checkout v1.27.1 && \
  go install google.golang.org/protobuf/cmd/protoc-gen-go

RUN \
  go get -d github.com/twitchtv/twirp/protoc-gen-twirp && \
  git -C "$(go env GOPATH)"/src/github.com/twitchtv/twirp checkout v8.1.1 && \
  go install github.com/twitchtv/twirp/protoc-gen-twirp

ENV GO111MODULE on
ENV CGO_ENABLED 0

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
COPY vendor /vendor
RUN go generate ./...
RUN go install

# TODO(shane): Run stage.
WORKDIR /proto
COPY docker/entrypoint /bin/entrypoint
ENTRYPOINT ["entrypoint"]
