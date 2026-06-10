-- Lives in after/lsp/ (not lsp/) so it overrides nvim-lspconfig's bundled
-- lsp/clangd.lua: rtp lsp/ files merge with later entries winning, and only
-- after/ comes after the plugin. Our regular lsp/ dir would lose the cmd.

-- Prefer Homebrew LLVM's clangd (Apple's is older and lacks flags); fall back to PATH
local brew_clangd = "/opt/homebrew/opt/llvm/bin/clangd"
local clangd = vim.uv.fs_stat(brew_clangd) and brew_clangd or "clangd"

return {
	cmd = {
		clangd,
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--experimental-modules-support",
	},
}
