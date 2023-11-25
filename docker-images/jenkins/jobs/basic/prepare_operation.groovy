job("prepare-operation") {
	description()
	scm {
		git {
			remote {
				github("nangashi/dcr", "https")
			}
			branch("*/feature/*")
		}
	}
	triggers {
		githubPush()
	}
	concurrentBuild(false)
}
