FROM jenkins/jenkins:2.431

ENV TZ="Asia/Tokyo"
ENV CASC_JENKINS_CONFIG="/var/jenkins_home/jenkins.yaml"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# install jenkins plugins
COPY ./config/plugins.txt /var/jenkins_home/plugins.txt
RUN jenkins-plugin-cli --plugin-file /var/jenkins_home/plugins.txt
