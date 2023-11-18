pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        // ビルドコマンドをここに追加
      }
    }
    stage('Test') {
      steps {
        echo 'Testing...'
        // テストコマンドをここに追加
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
        // デプロイコマンドをここに追加
      }
    }
  }
}
