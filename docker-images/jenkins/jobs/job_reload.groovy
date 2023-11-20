job('Reload-Jobs') {
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
cp -r ./docker-images/jenkins/jobs /var/jenkins_home/jobs
""")

    systemGroovyCommand("""
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

// ディレクトリ内のGroovyファイルを列挙するためのパス
def scriptsDir = new File('/var/jenkins_home/workspace/Reload-Jobs/docker-images/jenkins/jobs/')
def workspace = new File('.')

def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)
def scriptLoader = new DslScriptLoader(jobManagement)

// ディレクトリ内のすべてのGroovyファイルを処理
scriptsDir.eachFile { File file ->
    if (file.name.endsWith('.groovy')) {
        scriptLoader.runScript(file.text)
    }
}
""")
  }
}
