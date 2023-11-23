job('Reload-Configuration') {
  description('Reloads Jenkins Configuration as Code')

  // SCMを使用してリポジトリからファイルをチェックアウト
  scm {
    git {
      remote {
        url(System.getenv('GIT_REPOSITORY'))
      }
      branches('*/' + System.getenv('GIT_BRANCH'))
    }
  }

  steps {
    // Groovyスクリプトを実行してJCasCの設定をリロード
    shell("""
cp ./docker-images/jenkins/config/jenkins.yaml /var/jenkins_home/jenkins.yaml
""")

    systemGroovyCommand("""
import io.jenkins.plugins.casc.ConfigurationAsCode;

def path = "/var/jenkins_home/jenkins.yaml"
ConfigurationAsCode.get().configure(path)
""")
    // systemGroovyCommand(readFileFromWorkspace("/usr/share/jenkins/ref/init.groovy.d/basic-jobs/reload_config.groovy-command"))
  }
}
