GIT_VERSION=$(shell git describe --abbrev=4 --dirty --always --tags)
LDFLAGS=-ldflags="-X github.com/fsr/matthias/plugins/version.gitVersion=$(GIT_VERSION)"

run:
	go run $(LDFLAGS) matthias.go

build:
	go build $(LDFLAGS)

deploy:
	GOOS=linux GOARCH=386 go build $(LDFLAGS) matthias.go
	./upload.sh

.PHONY: run, build, deploy
