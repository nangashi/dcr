REPOSITORY=384081048358.dkr.ecr.ap-northeast-1.amazonaws.com
# Docker image name
IMAGE=$(REPOSITORY)/jenkins
# Docker image tag
TAG=2.431-3
# Dockerfile location
DOCKERFILE=Dockerfile

# Default target
all: build

# Build Docker image
build:
	docker build -t $(IMAGE):$(TAG) -f $(DOCKERFILE) .

# Run Docker image
run:
	# @make .ssm key=/google_oauth/client_id
	# client_id=$(ssm_value)
	# @make .ssm key=/google_oauth/client_secret
	# client_secret=$(ssm_value)
	docker run --rm \
		-p 8080:8080 \
		-e JENKINS_THEME_COLOR=blue \
		-e JENKINS_URL=http://localhost:8080/ \
		-e GIT_REPOSITORY=https://github.com/nangashi/dcr.git \
		-e GIT_BRANCH=feature/jenkins \
		-e GOOGLE_OAUTH2_CLIENT_ID=$(shell aws ssm get-parameter --name "/google_oauth/client_id" --with-decryption --query "Parameter.Value" --output text) \
		-e GOOGLE_OAUTH2_CLIENT_SECRET=$(shell aws ssm get-parameter --name "/google_oauth/client_secret" --with-decryption --query "Parameter.Value" --output text) \
		-v $(PWD)/config/jenkins.yaml:/var/jenkins_home/jenkins.yaml \
		-v $(PWD)/script/create_job.groovy:/usr/share/jenkins/ref/init.groovy.d/create_job.groovy \
		-v $(PWD)/jobs:/usr/share/jenkins/ref/init.groovy.d/job-dsl-scripts \
		$(IMAGE):$(TAG)

# Push Docker image to registry
push:
	aws ecr get-login-password | docker login --username AWS --password-stdin $(REPOSITORY)
	docker push $(IMAGE):$(TAG)

# Clean up
clean:
	docker rmi $(IMAGE):$(TAG)

# .ssm:
# # ssm_value=$(aws ssm get-parameter --name "${key}" --query "Parameter.Value" --output text 2>&1)
# # if [ $? -ne 0 ]; then
# # 	echo "SSMからの値の取得に失敗しました(${key}): ${ssm_value}"
# # 	exit 1
# # fi
# 	ssm_value=$(shell aws ssm get-parameter --name "$(key)" --with-decryption --query "Parameter.Value" --output text 2>&1)
# 	ssm_value := "hoge"
# 	echo $$ssm_value
# 	echo ${$ssm_value}
	# echo = "$(ssm_value)"
	# if [ $$(echo $$ssm_value | grep -c "error") -eq 0 ]; then \
	# 		echo "SSMからの値の取得に成功しました。"; \
	# else \
	# 		echo "エラー: SSMからの値の取得に失敗しました。エラーメッセージ: $$ssm_value"; \
	# 		exit 1; \
	# fi
