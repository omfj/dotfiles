vim.pack.add({
	{ src = "https://github.com/lervag/vimtex" },
})

vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "open"
-- Only the extra options; the rest of vimtex_compiler_latexmk is left at defaults
vim.g.vimtex_compiler_latexmk = {
	options = {
		"-verbose",
		"-file-line-error",
		"-synctex=1",
		"-interaction=nonstopmode",
		"-pdf",
		"-pdflatex=pdflatex",
		"-bibtex",
	},
}
