DOCKER_IMAGE=hugo

include Makefile.docker

PACKAGE_VERSION=0.1

include Makefile.package

.PHONY: check-version
check-version:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):latest version|awk '{ print $$2 }'|awk -F '-' '{ print $$1 }'

.PHONY: run
run:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):latest version
