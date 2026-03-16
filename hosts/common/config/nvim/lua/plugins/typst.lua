local jobs = {} -- keyed by bufnr

local function start_zathura_preview()
	local bufnr = vim.api.nvim_get_current_buf()
	local input = vim.api.nvim_buf_get_name(bufnr)
	local output = input:gsub("%.typ$", ".pdf")

	if jobs[bufnr] then
		return
	end

	local watch_id = vim.fn.jobstart({ "typst", "watch", input, output }, {
		detach = false,
		on_stderr = function(_, _) end,
	})
	local zathura_id = vim.fn.jobstart({ "zathura", output }, { detach = false })
	jobs[bufnr] = { watch = watch_id, zathura = zathura_id }
end

local function stop_zathura_preview()
	local bufnr = vim.api.nvim_get_current_buf()
	if not jobs[bufnr] then
		return
	end
	vim.fn.jobstop(jobs[bufnr].watch)
	vim.fn.jobstop(jobs[bufnr].zathura)
	jobs[bufnr] = nil
end

local function toggle_zathura_preview()
	local bufnr = vim.api.nvim_get_current_buf()
	if jobs[bufnr] then
		stop_zathura_preview()
	else
		start_zathura_preview()
	end
end

vim.api.nvim_create_autocmd("BufDelete", {
	group = vim.api.nvim_create_augroup("TypstZathuraCleanup", { clear = true }),
	pattern = "*.typ",
	callback = function(ev)
		local bufnr = ev.buf
		if jobs[bufnr] then
			vim.fn.jobstop(jobs[bufnr].watch)
			vim.fn.jobstop(jobs[bufnr].zathura)
			jobs[bufnr] = nil
		end
	end,
})

return {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "1.*",
	opts = {
		port = 9999,
		invert_colors = "auto", -- 'always', 'never' or 'auto'
		dependencies_bin = {
			["tinymist"] = "tinymist",
		},
	},
	keys = {
		{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
		{ "<leader>tu", "<cmd>TypstPreviewUpdate<cr>", desc = "Update Typst Preview" },
		{ "<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<cr>", desc = "Toggle Follow Cursor" },
		{
			"<leader>tz",
			toggle_zathura_preview,
			desc = "Toggle Zathura Preview",
			ft = "typst",
		},
	},
}
