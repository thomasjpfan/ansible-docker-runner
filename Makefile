.PHONY: setup_test clean_up build test cycle

PY_VERSION ?= 3
TAG ?= py$(PY_VERSION)
CONTAINER_NAME ?= ansible-docker-runner$(PY_VERSION)
CLI_COMMAND := docker run --rm -v $(PWD):/etc/ansible/roles/role_to_test \
	--name runner -v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v $(PWD)/dep_roles:/root/.ansible/roles \
	--network tests_over
DOCKER_HUB_REPO ?= thomasjpfan/ansible-docker-runner

build:
	docker build -t $(DOCKER_HUB):$(TAG) -f python$(PY_VERSION)/Dockerfile .

test:
	$(CLI_COMMAND) -ti $(DOCKER_HUB):$(TAG) cli all

cli:
	$(CLI_COMMAND) -ti $(DOCKER_HUB):$(TAG) /bin/sh

setup_test:
	docker-compose -f tests/docker-compose.yml up -d

clean_up:
	docker-compose -f tests/docker-compose.yml down


cycle: setup_test test clean_up