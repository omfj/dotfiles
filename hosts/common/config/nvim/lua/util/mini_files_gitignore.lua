-- Gitignore dimming for mini.files.
-- Based on MiniFilesGitignore by wroyca and dimming highlight by boydaihungst:
-- https://github.com/nvim-mini/mini.nvim/discussions/2265#discussioncomment-16541334

local uv = vim.uv

local M = {}
M.__index = M

function M.new()
	return setmetatable({
		cache = {},
		status_cache = {},
		git_roots = {},
		enabled = true,
	}, M)
end

function M:find_git_root(dir)
	if self.git_roots[dir] ~= nil then
		return self.git_roots[dir]
	end
	local current = dir
	while current and #current > 1 do
		if uv.fs_stat(current .. "/.git") then
			self.git_roots[dir] = current
			return current
		end
		current = vim.fn.fnamemodify(current, ":h")
	end
	self.git_roots[dir] = false
	return nil
end

function M:is_ignored(dir, path)
	if not self.enabled then
		return false
	end
	local cache = self.cache[dir]
	if not cache then
		return false
	end
	return cache[path] or false
end

function M:populate(dir, paths)
	local git_root = self:find_git_root(dir)
	if not git_root then
		self.cache[dir] = {}
		return
	end
	local result = vim.system(
		{ "git", "-C", git_root, "check-ignore", "--stdin" },
		{ stdin = table.concat(paths, "\n") }
	):wait()
	local ignored = {}
	if result.code <= 1 and result.stdout then
		for line in result.stdout:gmatch("[^\n]+") do
			if line ~= "" then
				ignored[line] = true
			end
		end
	end
	self.cache[dir] = ignored
	self:populate_status(git_root)
end

function M:populate_status(git_root)
	local result = vim.system({ "git", "-C", git_root, "status", "--porcelain" }):wait()
	local status = {}
	if result.code == 0 and result.stdout then
		for line in result.stdout:gmatch("[^\n]+") do
			if line ~= "" then
				local xy = line:sub(1, 2)
				local path_str = line:sub(4)
				local new_path = path_str:match(" -> (.+)$")
				if new_path then
					path_str = new_path
				end
				path_str = path_str:gsub("/$", "")
				local abs_path = git_root .. "/" .. path_str
				if xy:sub(1, 1) == "?" or xy:sub(2, 2) == "?" or xy:match("[Aa]") then
					status[abs_path] = "new"
				elseif xy:match("[Mm]") then
					status[abs_path] = "modified"
				end
			end
		end
	end
	self.status_cache[git_root] = status
end

function M:get_status(dir, path)
	local git_root = self:find_git_root(dir)
	if not git_root or not self.status_cache[git_root] then
		return nil
	end
	local status = self.status_cache[git_root]
	if status[path] then
		return status[path]
	end
	local prefix = path .. "/"
	for changed_path, cat in pairs(status) do
		if vim.startswith(changed_path, prefix) then
			return cat
		end
	end
	return nil
end

function M:sort_entries(fs_entries)
	local MiniFiles = require("mini.files")
	if not self.enabled or #fs_entries == 0 then
		return MiniFiles.default_sort(fs_entries)
	end
	local dir = vim.fs.dirname(fs_entries[1].path)
	if not self.cache[dir] then
		local paths = {}
		for _, entry in ipairs(fs_entries) do
			paths[#paths + 1] = entry.path
		end
		self:populate(dir, paths)
	end
	return MiniFiles.default_sort(fs_entries)
end

function M:toggle()
	self.enabled = not self.enabled
	if not self.enabled then
		self.cache = {}
	end
	self.status_cache = {}
	require("mini.files").refresh({ content = { force = true } })
end

function M:cleanup()
	self.cache = {}
	self.status_cache = {}
	self.git_roots = {}
end

return M
