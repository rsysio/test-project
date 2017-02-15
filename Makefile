SHELL := /bin/bash
SERVICE_NAME ?= smctest
AWS_REGION := eu-west-2
GIT_HASH := $(shell git rev-parse HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_LOGIN ?= $(shell aws --region $(AWS_REGION) ecr get-login)

.PHONY: ecr-createrepo
ecr-createrepo:
	aws --region $(AWS_REGION) \
		ecr describe-repositories \
		--repository-names $(SERVICE_NAME) \
		|&  grep RepositoryNotFoundException && \
		aws --region $(AWS_REGION) ecr create-repository \
		--repository-name $(SERVICE_NAME) || \
		echo "ECR repo exists"

.PHONY: ecr-uri
ecr-uri:
	@aws --region $(AWS_REGION) \
		ecr describe-repositories \
		--output text \
		--repository-names $(SERVICE_NAME) \
		--query 'repositories[0].repositoryUri'

.PHONY: ecr-login
ecr-login:
	@aws --region $(AWS_REGION) \
		ecr get-login

.PHONY: ecs-createtask
ecs-createtask:
	aws --region $(AWS_REGION) \
		ecs register-task-definition \
		--cli-input-json file://task.json

.PHONY: ecs-createservice
ecs-createservice:
	aws --region $(AWS_REGION) \
		ecs list-services \
		--cluster ${RUNNING_ENV}-ecs \
		--output json

.PHONY: docker-build
docker-build:
	docker run -it --rm -v ${PWD}:/app -v "${HOME}/.ivy2":/root/.ivy2 1science/sbt sbt docker:stage
	cd target/docker/stage && docker build -t $(SERVICE_NAME) .

.PHONY: docker-push
docker-push: DOCKER_REPO = $(shell make ecr-uri)
docker-push:
	docker tag $(SERVICE_NAME):latest $(DOCKER_REPO):${DOCKER_TAG} && \
	docker push $(DOCKER_REPO):${DOCKER_TAG}


