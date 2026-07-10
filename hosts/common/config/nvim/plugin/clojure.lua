vim.pack.add({
	{ src = "https://github.com/Olical/conjure" },
})

-- Conjure attaches to a running nREPL; start one with `lein repl` or
-- `clj -M:nrepl` and it auto-connects via the project's .nrepl-port file.
-- Evaluation keymaps live under <localleader> (e.g. ,ee ,er ,eb) in clojure buffers.

-- Diagnostics in the HUD/log buffer are just eval output, not code problems
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "conjure-log-*",
	callback = function(ev)
		vim.diagnostic.enable(false, { bufnr = ev.buf })
	end,
})
