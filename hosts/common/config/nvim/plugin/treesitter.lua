vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

local ensure_installed = {
	"bash",
	"c",
	"cpp",
	"diff",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"svelte",
	"astro",
	"css",
	"kotlin",
	"clojure",
	"rust",
	"vim",
	"vimdoc",
	"xml",
	"typst",
	"yaml",
	"go",
	"sql",
	"vue",
	"zig",
	"jinja",
	"templ",
	"java",
	"ocaml",
	"ocaml_interface",
	"ocamllex",
}

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local installed = require("nvim-treesitter.config").get_installed()
		local missing = vim.tbl_filter(function(lang)
			return not vim.tbl_contains(installed, lang)
		end, ensure_installed)
		if #missing > 0 then
			require("nvim-treesitter.install").install(missing, { summary = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- The main branch only configures behaviour in setup(); keymaps are set manually
require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select_objects = {
	aa = "@parameter.outer",
	ia = "@parameter.inner",
	af = "@function.outer",
	["if"] = "@function.inner",
	ac = "@class.outer",
	ic = "@class.inner",
	at = "@tag.outer",
	it = "@tag.inner",
}
for lhs, query in pairs(select_objects) do
	vim.keymap.set({ "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end, { desc = query })
end

local moves = {
	goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
	goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
	goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
	goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
}
for method, maps in pairs(moves) do
	for lhs, query in pairs(maps) do
		vim.keymap.set({ "n", "x", "o" }, lhs, function()
			require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
		end, { desc = method:gsub("_", " ") .. " " .. query })
	end
end

require("treesitter-context").setup({
	enable = true,
	max_lines = 3,
	mode = "cursor",
	trim_scope = "outer",
})

-- go to the context / header of the current line
-- ([C, not [c — [c/]c are taken by mini.diff hunk navigation in diffgit.lua)
vim.keymap.set("n", "[C", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Go to context" })
