job("create-job-with-dsl") {
	steps {
		dsl {
			text("")
			ignoreExisting(false)
			removeAction("IGNORE")
			removeViewAction("IGNORE")
		}
	}
}
