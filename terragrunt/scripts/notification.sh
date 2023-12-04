#!/bin/bash

# Slack Webhook URL
WEBHOOK_URL=$1
OUTPUT=$2
ENV=$3
MODULE=$4
RESULT=$5

echo $OUTPUT

current_branch=$(git branch --show-current)

# 成功または失敗の確認
if [ "${RESULT}" == 'success' ]; then
  message=$(cat <<END
<https://github.com/nangashi/dcr/tree/${current_branch}|Terraform | Applyに成功しました>
END
)
  color=good
else
  message=$(cat <<END
<https://github.com/nangashi/dcr/tree/${current_branch}|Terraform | Applyに失敗しました>
END
)
  color=danger
fi

# Slackに通知
curl -s -X POST -H 'Content-type: application/json' --data "$(cat <<END
{
  "attachments": [
    {
      "text": "${message}",
      "color": "${color}",
      "fields": [
        {
          "title": "user",
          "value": "$(aws sts get-caller-identity --output json | jq -r '.Arn' | cut -d '/' -f 2)",
          "short": true,
        },
        {
          "title": "env",
          "value": "${ENV}",
          "short": true,
        },
        {
          "title": "branch",
          "value": "${current_branch}",
          "short": true,
        },
        {
          "title": "module",
          "value": "${MODULE}",
          "short": true,
        },
      ]
    }
  ],
}
END
)" "${WEBHOOK_URL}"
