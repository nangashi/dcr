#!/bin/bash

set -eu

current_module=$(basename $(pwd))
type=$(echo "$@" |  awk '{print $1}')
if [ "$type" == "plan" ]; then
  tfcmt -var "target:${current_module}" plan -patch --skip-no-changes -- terraform "$@"
elif [ "$type" == "apply" ]; then
  tf_output=$(terraform "$@" -no-color 2>&1)

  # type=$(echo "$@" |  awk '{print $1}')
  # if [ "$type" != "plan" ] && [ "$type" != "apply" ]; then
  #   echo "$tf_output"
  #   exit 0
  # fi

  # 変更がないときは通知しない
  if echo "$tf_output" | grep -q "No changes. Your infrastructure matches the configuration."; then
      echo "No changes found. Exiting..."
      exit 0
  fi
  # applyを取り消したときは通知しない
  if echo "$tf_output" | grep -q "Apply cancelled."; then
      exit 0
  fi

  message="Terraform $TF_VAR_env - $current_module"
  echo "$tf_output" \
    | sed '/Terraform will perform the following actions/,$!d' \
    | tfnotify --config "${TFNOTIFY_CONFIG:-}" "$type" --message "$message"
else
  terraform "$@"
fi
