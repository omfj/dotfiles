vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local bufremove = require("mini.bufremove")
bufremove.setup()

require("mini.tabline").setup({
	show_icons = false,
})

local function listed_buffers()
	return vim.tbl_filter(function(buf)
		return vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())
end

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bc", function()
	bufremove.delete(0, false)
end, { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bD", function()
	bufremove.delete(0, true)
end, { desc = "Delete Buffer (force)" })
vim.keymap.set("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(listed_buffers()) do
		if buf ~= current then
			bufremove.delete(buf, false)
		end
	end
end, { desc = "Delete Other Buffers" })

for i = 1, 9 do
	vim.keymap.set("n", "<C-w>" .. i, function()
		local buf = listed_buffers()[i]
		if buf then
			vim.api.nvim_set_current_buf(buf)
		end
	end, { desc = "Go to buffer " .. i })
end
