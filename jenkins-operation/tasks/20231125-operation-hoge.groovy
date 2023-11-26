@Library('libs@feature/jenkins') _
pipeline {
  agent any
  stages {
    stage('Query Database') {
      steps {
        script {
          def result = connect_db.executeQuery('SELECT * FROM your_table')
          echo "Query result: ${result}"
        }
      }
    }
  }
}
