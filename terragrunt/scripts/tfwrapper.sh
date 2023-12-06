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

# #!/bin/bash

# set -euo pipefail

# # コマンドの種類を取得(例: apply, plan, fmt...)
# type=$(echo "$@" |  awk '{print $1}')

# # 実行しているディレクトリ名を取得
# current_dir=$(pwd | sed 's/.*\///g')

# if [ "$type" == "plan" ]; then
#     # planのときは-patchオプションを付ける
#     # 実行ディレクトリ名をターゲットとして指定
#     tfcmt -var "target:${current_dir}" plan --patch --skip-no-changes -- terraform "$@"
#     echo tfcmt -var "target:${current_dir}" plan --patch --skip-no-changes -- terraform "$@"
# elif [ "$type" == "apply" ]; then
#     tfcmt -var "target:${current_dir}" apply --skip-no-changes -- terraform "$@"
# else
#     terraform "$@"
# fi
