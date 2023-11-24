FROM jenkins/jenkins:2.431

ENV TZ="Asia/Tokyo"
ENV CASC_JENKINS_CONFIG="/var/jenkins_config/jenkins.yaml"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# copy jcasc config
COPY ./config/jenkins.yaml /var/jenkins_config/jenkins.yaml

# install jenkins plugins
COPY ./config/plugins.txt /var/jenkins_config/plugins.txt
RUN jenkins-plugin-cli --plugin-file /var/jenkins_config/plugins.txt

# create job
COPY ./script/* /usr/share/jenkins/ref/init.groovy.d/
COPY ./jobs/basic/ /usr/share/jenkins/ref/init.groovy.d/basic-jobs/
