# 環境変数チェック
ifndef ENV
	$(error ENV is undefined)
endif
ifndef AWS_ACCOUNT_ID
	$(error AWS_ACCOUNT_ID is undefined)
endif

# 変数定義
SHELL := /bin/bash
MAKEFILE_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
LAMBDA_FUNCTION_NAME := MonthlyAggregate-$(ENV)
ECR_REPOSITORY := $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com
ECR_IMAGE_NAME := monthly_aggregate
ECR_IMAGE_TAG := $(shell date '+%Y%m%d-%H%M%S')
# 開発環境ではaws-vaultで認証する
ifeq ($(ENV),dev)
	AWS_VAULT := aws-vault exec developer --
endif

.PHONY: test build deploy

test:
	@python -m pytest

build: test
	docker build -t $(AWS_ECR_REPOSITORY)/$(ECR_IMAGE_NAME):$(ECR_IMAGE_TAG) .
	docker tag $(AWS_ECR_REPOSITORY)/$(ECR_IMAGE_NAME):$(ECR_IMAGE_TAG) $(ECR_IMAGE_NAME):latest

deploy: build
	$(AWS_VAULT) aws ecr get-login-password | docker login --username AWS --password-stdin $(ECR_REPOSITORY)
	docker push $(ECR_REPOSITORY)/$(ECR_IMAGE_NAME):$(ECR_IMAGE_TAG)
	$(AWS_VAULT) aws lambda update-function-code --function-name $(LAMBDA_FUNCTION_NAME) --image-uri $(ECR_REPOSITORY)/$(PROGRAM_NAME):$(ECR_IMAGE_TAG)
