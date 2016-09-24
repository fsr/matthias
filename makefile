GIT_VERSION=$(shell git describe --abbrev=4 --dirty --always --tags)
VERSION_FLAGS=-ldflags="-X github.com/fsr/matthias/plugins/version.gitVersion=$(GIT_VERSION)"

run:
	go run $(VERSION_FLAGS) matthias.go

build:
	go build $(VERSION_FLAGS)

deploy:
	GOOS=linux GOARCH=386 go build $(VERSION_FLAGS) matthias.go
	./upload.sh

.PHONY: run, build, deploy
