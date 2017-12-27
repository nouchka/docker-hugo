DOCKER_IMAGE=hugo
DOCKER_NAMESPACE=nouchka
prefix = /usr/local

.DEFAULT_GOAL := build

build:
	docker build -t $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) .

run:
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE)

check:
	docker run --rm -i hadolint/hadolint < Dockerfile

test: build run check
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) version

install:
	install bin/$(DOCKER_IMAGE) $(prefix)/bin
