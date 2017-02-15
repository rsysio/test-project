SHELL := /bin/bash
SERVICE_NAME ?= test-project
AWS_REGION := eu-west-2
GIT_HASH := $(shell git rev-parse HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_LOGIN ?= $(shell aws --region $(AWS_REGION) ecr get-login)

.PHONY: create-ecr-repo
ecr-createrepo:
	aws --region $(AWS_REGION) ecr describe-repositories \
		--repository-names $(SERVICE_NAME) \
		|&  grep RepositoryNotFoundException && \
		aws --region $(AWS_REGION) ecr create-repository \
		--repository-name $(SERVICE_NAME) || \
		echo "ECR repo exists"

.PHONY: get-ecr-uri
ecr-uri:
	aws --region $(AWS_REGION) ecr describe-repositories \
		--repository-names $(SERVICE_NAME) \
		--query 'repositories[0].repositoryUri'

ecr-login:
	@aws --region $(AWS_REGION) ecr get-login

.PHONY: docker-build
docker-build:
	docker run -it --rm -v ${PWD}:/app 1science/sbt sbt docker:stage
	cd target/docker/stage && docker build -t $(SERVICE_NAME) .

.PHONY: docker-push
docker-push:
	DOCKER_REPO=$$(make ecr-uri)
	docker tag $(SERVICE_NAME):latest ${DOCKER_REPO}:${DOCKER_TAG}
	docker push ${DOCKER_REPO}:${DOCKER_TAG}

.PHONY: create-ecs-service
create-ecs-service:
	aws --region $(AWS_REGION) ecs create-service
