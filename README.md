# Environment

## aws
384081048358
https://ap-northeast-1.console.aws.amazon.com/console/home?region=ap-northeast-1

## requirements

- tfenv
- terragrunt
- aws vault

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
aws-vault add <user_profile>
```

設定
~/.aws/config
```
[profile user]
region=ap-northeast-1
output=json
mfa_serial=arn:aws:iam::<account_id>:mfa/<mfa>

[profile admin]
source_profile=user
role_arn=arn:aws:iam::<account_id>:role/<role_name>
mfa_serial=arn:aws:iam::<account_id>:mfa/<mfa>
```

```
```

動作確認
```
aws-vault exec admin
aws s3 ls
exit
```
