return {
	cmd = {
		"jdtls",
		"-data",
		vim.fn.expand("~/.local/share/nvim/jdtls-workspace/") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	},
	root_dir = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" }),
}
