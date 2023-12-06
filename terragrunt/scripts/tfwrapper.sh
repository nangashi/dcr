#!/bin/bash

set -eu

TERRAFORM_OUTPUT_FILE=./terraform.log

terraform "$@" -no-color 2>&1 | tee ${TERRAFORM_OUTPUT_FILE}

type=$(echo "$@" |  awk '{print $1}')

if [ "$type" != "plan" ] && [ "$type" != "apply" ]; then
  exit 0
fi

# 変更がないときは通知しない
if grep -q "No changes. Your infrastructure matches the configuration." "${TERRAFORM_OUTPUT_FILE}"; then
    echo "No changes found. Exiting..."
    exit 0
fi

# applyを取り消したときは通知しない
if grep -q "Apply cancelled." "${TERRAFORM_OUTPUT_FILE}"; then
    exit 0
fi

current_module=$(basename $(pwd))
tfnotify --config "${TFNOTIFY_CONFIG}" "$type" --message "Terraform $TF_VAR_env - $current_module" < ${TERRAFORM_OUTPUT_FILE}
