import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

// ディレクトリ内のGroovyファイルを列挙するためのパス
def workspace = new File('.')

def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)
def scriptLoader = new DslScriptLoader(jobManagement)

// ディレクトリ内のすべてのGroovyファイルを処理
def basicJobsDir = new File('/usr/share/jenkins/ref/init.groovy.d/basic-jobs/')
basicJobsDir.eachFile { File file ->
  if (file.name.endsWith('.groovy')) {
    scriptLoader.runScript(file.text)
  }
}

def operationJobsDir = new File('/usr/share/jenkins/ref/init.groovy.d/operation-jobs/')
if (operationJobsDir.exists()) {
  operationJobsDir.eachFile { File file ->
    if (file.name.endsWith('.groovy')) {
      scriptLoader.runScript(file.text)
    }
  }
}

def developJobsDir = new File('/usr/share/jenkins/ref/init.groovy.d/develop-jobs/')
if (developJobsDir.exists()) {
  developJobsDir.eachFile { File file ->
    if (file.name.endsWith('.groovy')) {
      scriptLoader.runScript(file.text)
    }
  }
}
