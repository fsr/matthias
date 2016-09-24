SOURCEDIR = .
SOURCES := $(shell find $(SOURCEDIR) -type f -name '*.go' -not -path "$(SOURCEDIR)/vendor/*")

# Go tools
GOCMD = go
GOFMT = gofmt -w

# Version, can be output by matthias with `!version`
GIT_VERSION = $(shell git describe --dirty --always)
WHOAMI = $(shell whoami)
LDFLAGS = -ldflags="-X github.com/fsr/matthias/plugins/version.gitVersion=$(GIT_VERSION)@$(WHOAMI)"

run:
	$(shell $(GOCMD) run $(LDFLAGS) matthias.go)

all:
	$(shell $(GOCMD) build $(LDFLAGS) matthias.go)

fmt:
	$(shell $(GOFMT) $(SOURCES))

deploy:
	$(shell GOOS=linux GOARCH=386 $(GOCMD) build $(LDFLAGS) matthias.go)
	$(shell ./upload.sh)

.PHONY: run all fmt deploy
