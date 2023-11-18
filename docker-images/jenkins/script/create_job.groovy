import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

// ディレクトリ内のGroovyファイルを列挙するためのパス
def scriptsDir = new File('/usr/share/jenkins/ref/init.groovy.d/job-dsl-scripts/')
def workspace = new File('.')

def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)
def scriptLoader = new DslScriptLoader(jobManagement)

// ディレクトリ内のすべてのGroovyファイルを処理
scriptsDir.eachFile { File file ->
    if (file.name.endsWith('.groovy')) {
        scriptLoader.runScript(file.text)
    }
}
