-- Persistent cycling toggles backed by index files in stdpath("data").
-- Usage:
--   local pt = require("util.persist_toggle")
--
--   -- Define a cycle (call once at startup to restore state)
--   pt.define("conceal", {
--     steps = {
--       { label = "off",  apply = function() vim.opt.conceallevel = 0 end },
--       { label = "2",    apply = function() vim.opt.conceallevel = 2 end },
--       { label = "3",    apply = function() vim.opt.conceallevel = 3 end },
--     },
--     default = 1, -- 1-based index into steps
--   })
--
--   -- Wire to a keymap
--   map("n", "<leader>uc", function() pt.cycle("conceal") end, { desc = "Cycle Conceal" })

local M = {}

local data_dir = vim.fn.stdpath("data") .. "/persist_toggles"

local registry = {}

local function idx_path(name)
	return data_dir .. "/" .. name
end

local function read_idx(name)
	local fd = io.open(idx_path(name), "r")
	if not fd then
		return nil
	end
	local val = tonumber(fd:read("*l"))
	fd:close()
	return val
end

local function write_idx(name, idx)
	vim.fn.mkdir(data_dir, "p")
	local fd = io.open(idx_path(name), "w")
	if fd then
		fd:write(tostring(idx))
		fd:close()
	end
end

--- Define and immediately restore a persistent cycle.
--- @param name string  unique key for this cycle
--- @param opts { steps: { label: string, apply: fun() }[], default: integer }
function M.define(name, opts)
	registry[name] = opts
	local idx = read_idx(name) or opts.default or 1
	idx = math.max(1, math.min(idx, #opts.steps))
	write_idx(name, idx)
	opts.steps[idx].apply()
end

--- Advance to the next step and persist.
--- @param name string
function M.cycle(name)
	local opts = registry[name]
	if not opts then
		vim.notify("persist_toggle: no cycle defined for " .. name, vim.log.levels.ERROR)
		return
	end
	local idx = read_idx(name) or 1
	local next_idx = (idx % #opts.steps) + 1
	write_idx(name, next_idx)
	local step = opts.steps[next_idx]
	step.apply()
	vim.notify(name .. ": " .. step.label, vim.log.levels.INFO)
end

return M
