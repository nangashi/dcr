REPOSITORY=$(AWS_ACCOUND_ID).dkr.ecr.ap-northeast-1.amazonaws.com
# Docker image name
IMAGE=$(REPOSITORY)/jenkins
# Docker image tag
TAG=$(shell grep 'current_tag =' ../terraform.tfvars | sed -n 's/.*current_tag = "\([^"]*\)".*/\1/p')
# Dockerfile location
DOCKERFILE=Dockerfile

# Default target
all: build

# Build Docker image
build:
	docker build -t $(IMAGE):$(TAG) -f $(DOCKERFILE) .

# Run Docker image
run:
	docker run --rm \
		-p 8080:8080 \
		-e JENKINS_THEME_COLOR=blue \
		-e JENKINS_URL=http://localhost:8080/ \
		-e GIT_REPOSITORY=https://github.com/nangashi/dcr.git \
		-e GIT_BRANCH=feature/jenkins \
		-e GOOGLE_OAUTH2_CLIENT_ID=$(shell aws ssm get-parameter --name "/google_oauth/client_id" --with-decryption --query "Parameter.Value" --output text) \
		-e GOOGLE_OAUTH2_CLIENT_SECRET=$(shell aws ssm get-parameter --name "/google_oauth/client_secret" --with-decryption --query "Parameter.Value" --output text) \
		-v $(PWD)/script/create_job.groovy:/usr/share/jenkins/ref/init.groovy.d/create_job.groovy \
		-v $(PWD)/jobs/develop:/usr/share/jenkins/ref/init.groovy.d/develop-jobs \
		-v $(PWD)/jobs/operation:/usr/share/jenkins/ref/init.groovy.d/operation-jobs \
		$(IMAGE):$(TAG)

# Push Docker image to registry
push:
	aws ecr get-login-password | docker login --username AWS --password-stdin $(REPOSITORY)
	docker push $(IMAGE):$(TAG)

# Clean up
clean:
	docker rmi $(IMAGE):$(TAG)
