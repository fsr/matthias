GIT_VERSION = $(shell git describe --dirty --always)
WHOAMI = $(shell whoami)
LDFLAGS = -ldflags="-X github.com/fsr/matthias/plugins/version.gitVersion=$(GIT_VERSION)@$(WHOAMI)"

SOURCES := $(shell find . -type f -name '*.go' -not -path "./vendor/*")

build:
	$(shell go build $(LDFLAGS) matthias.go)

fmt:
	$(shell gofmt -w $(SOURCES))

deploy:
	$(shell GOOS=linux GOARCH=386 go build $(LDFLAGS) matthias.go)
	$(shell ./upload.sh)
	$(shell rm matthias)

.PHONY: build fmt deploy
