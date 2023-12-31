# デフォルトでは開発環境で動作する
ENV ?= dev
# terragruntがキャッシュディレクトリで動作するため絶対パスで扱う
MAKEFILE_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TF_WRAPPER := $(MAKEFILE_PATH)/scripts/tfwrapper.sh
TFNOTIFY_CONFIG := $(MAKEFILE_PATH)/scripts/tfnotify_slack.yaml
# ローカル（GitHub Actions以外）ではaws-vaultで認証する
ifndef CI
	AWS_VAULT := aws-vault exec developer --
endif


.PHONY: check run init init-dev init-stg init-prd plan plan-dev plan-stg plan-prd apply apply-dev apply-stg apply-prd

check:
	$(MAKE) run CMD=check

# init ターゲット
init:
	$(MAKE) run CMD=init

# plan ターゲット
plan:
	$(MAKE) run CMD=plan

# apply ターゲット
apply:
	$(MAKE) run CMD=apply

# 実行コマンド
run:
	$(eval MODULE_PATH := $(if $(MODULE),envs/$(ENV)/$(MODULE),envs/$(ENV)))
	@$(MAKE) $(CMD)-$(ENV) DIR=$(MODULE_PATH)

check-dev:
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) validate
	@$(AWS_VAULT) tflint --init --config=$(shell pwd)/.tflint.hcl
	@$(AWS_VAULT) tflint --recursive --config=$(shell pwd)/.tflint.hcl


# Terraform init
init-dev init-stg init-prd:
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) init

# 開発環境用のplan
plan-dev: check
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) plan

# ステージング/本番環境用のplan
plan-stg plan-prd:
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) plan --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# 開発環境用のapply
apply-dev:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	export TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# ステージング/本番環境用のapply
apply-stg apply-prd:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	export TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive
