# Environment

## aws
384081048358
https://ap-northeast-1.console.aws.amazon.com/console/home?region=ap-northeast-1

## requirements

- direnv
- tfenv
- terragrunt
- tfnotify
- aws-vault
- xdg-utils
- SlackApp for tfnotify (https://api.slack.com/apps)

## 構築

### aws-vault(WSL2)



```
brew install aws-vault pass gnupg
echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
gpgconf --reload gpg-agent
gpg --gen-key
gpg --list-keys
pass init <key id>
cat <<END >> ~/.zshrc
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_SESSION_TOKEN_TTL=12h
END
source ~/.zshrc
aws-vault add operator
```

設定
~/.aws/config
```
[profile operator]
region=ap-northeast-1
output=json
mfa_serial=arn:aws:iam::<account_id>:mfa/<mfa>

[profile developer]
source_profile=operator
role_arn=arn:aws:iam::<account_id>:role/<role_name>
mfa_serial=arn:aws:iam::<account_id>:mfa/<mfa>
```


動作確認
```
aws-vault exec developer
aws s3 ls
exit
```

## 権限

|環境|ログイン可否|管理者| | |開発者| | |
|:----|:----|:----|:----|:----|:----|:----|:----|
| | |mfa無し|mfa有り|ロール変更|mfa無し|mfa有り|ロール変更|
|開発|可|MfaOnly|Operator|Administrator|MfaOnly|Operator|PowerUser|
|ステージング|否|MfaOnly|-|Administrator|MfaOnly|-|Operator|
|本番|否|MfaOnly|-|Administrator|MfaOnly|-|Operator|
