vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
})

-- Defer all dap setup to first use: nothing here is needed until a debug
-- keymap is pressed, and the requires cost ~10ms at startup.
local did_setup = false
local function load_dap()
	local dap = require("dap")
	if did_setup then
		return dap
	end
	did_setup = true

	local dapui = require("dapui")

	dap.defaults.fallback.external_terminal = {
		command = "tmux",
		args = { "new-window" },
	}

	require("nvim-dap-virtual-text").setup()

	dapui.setup()

	-- Auto open/close UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- Go
	require("dap-go").setup()

	-- Adapters (no default configs — use .vscode/launch.json per project)
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
			args = { "--port", "${port}" },
		},
	}

	local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
	for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
		dap.adapters[adapter] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
			},
		}
	end

	-- Auto-load .vscode/launch.json if present
	local launch_json = vim.fn.getcwd() .. "/.vscode/launch.json"
	if vim.uv.fs_stat(launch_json) then
		require("dap.ext.vscode").load_launchjs()
	end

	return dap
end

-- Signs (cheap, and breakpoints placed before the first debug session
-- should already render correctly)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "✘", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

-- Keymaps
-- stylua: ignore start
vim.keymap.set("n", "<leader>db", function() load_dap().toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() load_dap().set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() load_dap().continue() end, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", function() load_dap().run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>di", function() load_dap().step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function() load_dap().step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dO", function() load_dap().step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dq", function() load_dap().terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dr", function() load_dap().repl.open() end, { desc = "REPL" })
vim.keymap.set("n", "<leader>dl", function() load_dap().run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>du", function() load_dap(); require("dapui").toggle() end, { desc = "Toggle UI" })
vim.keymap.set("n", "<leader>dgt", function() load_dap(); require("dap-go").debug_test() end, { desc = "Debug Go Test" })
vim.keymap.set("n", "<leader>dgT", function() load_dap(); require("dap-go").debug_last_test() end, { desc = "Debug Last Go Test" })
vim.keymap.set("n", "<leader>dL", function() load_dap(); require("dap.ext.vscode").load_launchjs() vim.notify("launch.json loaded") end, { desc = "Load launch.json" })
-- stylua: ignore end
