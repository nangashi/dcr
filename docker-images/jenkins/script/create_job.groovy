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

def jobsDir = new File('/usr/share/jenkins/ref/init.groovy.d/jobs/')
if (jobsDir.exists()) {
  jobsDir.eachFile { File file ->
    if (file.name.endsWith('.groovy')) {
      scriptLoader.runScript(file.text)
    }
  }
}
