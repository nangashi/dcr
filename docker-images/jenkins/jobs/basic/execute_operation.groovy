pipelineJob('execute-operation') {
  parameters {
    stringParam('JENKINSFILE', '', 'Jenkinsfile script for operation.')
  }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/nangashi/dcr.git')
          }
          branches('*/feature/jenkins')
          scriptPath('jenkins-operation/${JENKINSFILE}.groovy')
        }
      }
    }
  }
}
