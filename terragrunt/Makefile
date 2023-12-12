# デフォルトでは開発環境で動作する
ENV ?= dev
# terragruntがキャッシュディレクトリで動作するため絶対パスで扱う
MAKEFILE_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TF_WRAPPER := $(MAKEFILE_PATH)/scripts/tfwrapper.sh
TFNOTIFY_CONFIG := $(MAKEFILE_PATH)/scripts/tfnotify_slack.yaml
# 開発環境ではaws-vaultで認証する
# ifeq ($(ENV),dev)
	AWS_VAULT := aws-vault exec admin --
# endif


.PHONY: help check plan apply plan-dev apply-dev plan-stg plan-prd apply-stg apply-prd

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  make plan MODULE=<モジュール名> - Terraform Planを実行"
	@echo "  make apply MODULE=<モジュール名> - Terraform Applyを実行"

check:
	@$(AWS_VAULT) tflint --init --config=$(shell pwd)/.tflint.hcl
	@$(AWS_VAULT) tflint --recursive --config=$(shell pwd)/.tflint.hcl

# plan ターゲット
plan: check
	$(MAKE) run CMD=plan

# apply ターゲット
apply:
	$(MAKE) run CMD=apply

# 実行コマンド
run:
	$(eval MODULE_PATH := $(if $(MODULE),envs/$(ENV)/$(MODULE),envs/$(ENV)))
	@$(MAKE) $(CMD)-$(ENV) DIR=$(MODULE_PATH)

# 開発環境用のplan
plan-dev:
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) plan

# 開発環境用のapply
apply-dev:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell aws ssm get-parameter --name "/$(ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell aws ssm get-parameter --name "/$(ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	export TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# ステージング/本番環境用のplan
plan-stg plan-prd:
	@cd $(DIR); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) plan --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive

# ステージング/本番環境用のapply
apply-stg apply-prd:
	@cd $(DIR); \
	export SLACK_TOKEN=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/oauth_token" --with-decryption --query "Parameter.Value" --output text); \
	export SLACK_CHANNEL_ID=$(shell $(AWS_VAULT) aws ssm get-parameter --name "/$(ENV)/slack/channel_id" --with-decryption --query "Parameter.Value" --output text); \
	export TFNOTIFY_CONFIG=$(TFNOTIFY_CONFIG); \
	$(AWS_VAULT) terragrunt $(if $(MODULE),,run-all) apply --terragrunt-tfpath $(TF_WRAPPER) --terragrunt-non-interactive
