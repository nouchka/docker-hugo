DOCKER_NAMESPACE=nouchka
DOCKER_IMAGE=hugo

.DEFAULT_GOAL := build

build:
	docker build -t $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) .

run:
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE)

check:
	hadolint

test: build run check
	docker run $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) version
