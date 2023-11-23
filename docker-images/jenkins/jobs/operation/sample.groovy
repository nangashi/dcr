job('sample-job') {
    description('これはサンプルのフリースタイルジョブです。')

    // scm {
    //     git('https://github.com/example/repo.git')
    // }

    // triggers {
    //     scm('H/15 * * * *') // 15分ごとにリポジトリの変更をチェック
    // }

    steps {
        shell('echo "ビルド開始"; make build; echo "ビルド終了"')
    }

    publishers {
        archiveArtifacts('**/target/*.jar') // ビルド後にアーティファクトをアーカイブ
    }
}
