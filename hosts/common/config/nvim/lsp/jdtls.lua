local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

local bundles = vim.split(
	vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
	"\n",
	{ trimempty = true }
)

vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar"),
		"\n",
		{ trimempty = true }
	)
)

jdtls.start_or_attach({
	cmd = {
		"jdtls",
		"-data",
		vim.fn.expand("~/.local/share/nvim/jdtls-workspace/") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	},
	root_dir = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" }),
	init_options = {
		bundles = bundles,
	},
	on_attach = function(_, _)
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls.update_project_config()
	end,
})
