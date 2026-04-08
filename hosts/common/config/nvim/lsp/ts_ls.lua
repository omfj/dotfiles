return {
	root_markers = { "package.json", "tsconfig.json" },
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
				languages = { "vue" },
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
}
