# デフォルトの環境
TF_ENV ?= dev
MAKEFILE_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TF_WRAPPER := $(MAKEFILE_PATH)/scripts/tfwrapper.sh
TFNOTIFY_CONFIG := $(MAKEFILE_PATH)/scripts/tfnotify_slack.yaml

.PHONY: plan apply help plan-dev apply-dev plan-stg plan-prd apply-stg apply-prd

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  make plan MODULE=<モジュール名> - Terraform Planを実行"
	@echo "  make apply MODULE=<モジュール名> - Terraform Applyを実行"

# plan ターゲット
plan:
	$(MAKE) run CMD=plan

# apply ターゲット
apply:
	$(MAKE) run CMD=apply

# 実行コマンド
run:
	$(eval MODULE_PATH := $(if $(MODULE),envs/$(TF_ENV)/$(MODULE),envs/$(TF_ENV)))
	@$(MAKE) $(CMD)-$(TF_ENV) DIR=$(MODULE_PATH)

# dev環境用のplan
plan-dev:
	@cd $(DIR); \
	terragrunt $(if $(MODULE),,run-all) plan

# dev環境用のapply
apply-dev:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell aws ssm get-parameter --name "/$(TF_ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell aws ssm get-parameter --name "/$(TF_ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# stg/prd環境用のplan
plan-stg plan-prd:
	@cd $(DIR); \
	terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# stg/prd環境用のapply
apply-stg apply-prd:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell aws ssm get-parameter --name "/$(TF_ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell aws ssm get-parameter --name "/$(TF_ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive
