SHELL := /bin/bash
IMAGE = cherry-pick
TAG ?= $(shell git rev-parse --short HEAD)

.PHONY: build
build:
	docker build -t ${IMAGE}:${TAG} .

.PHONY: run
run:
	docker run -e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-e GITHUB_ACTOR=LivestormBot \
		-e GITBOT_EMAIL=devops@livestorm.co \
		${IMAGE}:${TAG}
