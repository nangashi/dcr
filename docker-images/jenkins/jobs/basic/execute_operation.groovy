pipelineJob("execute-operation") {
	description()
	parameters {
		activeChoiceParam("script") {
			groovyScript {
				script("""import java.io.File

// 特定のディレクトリパスを指定
def dirPath = '/var/jenkins_home/workspace/prepare-operation/jenkins-operation'

// ディレクトリ内のファイルをリスト化
def dir = new File(dirPath)
def fileList = []

// ディレクトリが存在し、ディレクトリであるか確認
if (dir.exists() && dir.isDirectory()) {
    // 拡張子が .groovy のファイルをリスト化
    dir.eachFile { file ->
        if (file.name.endsWith('.groovy')) {
            // 拡張子を除いたファイル名をリストに追加
            fileList.add(file.name[0..-8]) // ".groovy" は7文字なので、最後から7文字を除去
        }
    }
}

// ファイル名のリストを返す
return fileList
""")
				fallbackScript("")
			}
			choiceType("SINGLE_SELECT")
			filterable(false)
		}
	}
// 	definition {
// 		cpsScm {
// ""		}
// 	}
	disabled(false)
}
