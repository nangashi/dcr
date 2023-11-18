FROM jenkins/jenkins:2.431

ENV TZ="Asia/Tokyo"
ENV CASC_JENKINS_CONFIG="/config/jenkins.yaml"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Jenkins設定
COPY ./config/jenkins.yaml $CASC_JENKINS_CONFIG

# install jenkins plugins
COPY ./config/plugins.txt /config/plugins.txt
RUN jenkins-plugin-cli --plugin-file /config/plugins.txt

# create job
COPY ./script/create_job.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY ./jobs /usr/share/jenkins/ref/init.groovy.d/job-dsl-scripts
