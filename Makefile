SERVICE_REGIONS_PATH := ${PWD}/service-regions

################################################################################
# AWSCLIコマンドのDocker
################################################################################
DOCKER_AWSCLI_TAG           := 2.0.19
DOCKER_REPOSITORY_NAME      := my-awscli
AWS_SHARED_CREDENTIALS_PATH := /tmp/AWS_SHARED_CREDENTIALS
build:
	docker build . \
		--build-arg DOCKER_AWSCLI_TAG=$(DOCKER_AWSCLI_TAG) \
		--tag $(DOCKER_REPOSITORY_NAME):latest
bash:
	mkdir -p ${HOME}/.aws/
	$(eval WORKDIR := $(shell docker run --rm --entrypoint pwd $(DOCKER_REPOSITORY_NAME):latest))
	docker run \
		--rm \
		--interactive \
		--tty \
		--user `id -u`:`id -g` \
		--mount type=bind,source=$(PWD)/,target=$(WORKDIR)/ \
		--mount type=bind,source=${HOME}/.aws/,target=/.aws/ \
		--entrypoint '' \
		$(DOCKER_REPOSITORY_NAME):latest bash

clean:
	rm service-regions/*-regions.all