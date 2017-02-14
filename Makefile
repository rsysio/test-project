SHELL := /bin/bash
PROJECT_NAME ?= test-project
GIT_HASH ?= $(shell git rev-parse HEAD)
GIT_BRANCH ?= $(git rev-parse --abbrev-ref HEAD)

.PHONY: create-ecr
create-ecr:
	aws ecr describe-repositories --repository-names ${PROJECT_NAME} || \
		aws ecr create-repository --repository-name ${PROJECT_NAME}

.PHONY: docker-build
docker-build:
	docker run -it --rm -v ${PWD}:/app 1science/sbt sbt docker:stage
	cd target/docker/stage && docker build -t ${PROJECT_NAME} .

.PHONY: docker-push
docker-push:
	docker tag ${PROJECT_NAME}:latest ${DOCKER_REPO}:${DOCKER_TAG}
	docker push ${DOCKER_REPO}:${DOCKER_TAG}

