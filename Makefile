SHELL := /bin/bash
PROJECT_NAME ?= test-project
AWS_REGION ?= eu-west-2
GIT_HASH ?= $(shell git rev-parse HEAD)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_LOGIN ?= $(shell aws --region $(AWS_REGION) ecr get-login)

.PHONY: create-ecr
create-ecr:
	aws --region $(AWS_REGION) ecr describe-repositories --repository-names $(PROJECT_NAME) || \
		aws --region $(AWS_REGION) ecr create-repository --repository-name $(PROJECT_NAME)

.PHONY: docker-build
docker-build:
	docker run -it --rm -v ${PWD}:/app 1science/sbt sbt docker:stage
	cd target/docker/stage && docker build -t $(PROJECT_NAME) .

.PHONY: docker-push
docker-push:
	docker tag $(PROJECT_NAME):latest ${DOCKER_REPO}:${DOCKER_TAG}
	docker push ${DOCKER_REPO}:${DOCKER_TAG}

