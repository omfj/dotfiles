local M = {}

local MODEL = "gpt-4o-mini"
local CONTEXT_LINES = 10

--- Gather surrounding buffer lines (CONTEXT_LINES above and below the cursor)
--- and return them as a single string with a marker on the cursor line.
---
---@param bufnr integer
---@param cursor integer[]  { row, col } 1-based
---@return string
local function get_buffer_context(bufnr, cursor)
	local row = cursor[1] -- 1-based
	local total = vim.api.nvim_buf_line_count(bufnr)
	local first = math.max(1, row - CONTEXT_LINES)
	local last = math.min(total, row + CONTEXT_LINES)
	-- nvim_buf_get_lines uses 0-based, end-exclusive
	local lines = vim.api.nvim_buf_get_lines(bufnr, first - 1, last, false)
	-- Mark the cursor line so the model knows exactly which line is relevant
	local cursor_idx = row - first + 1
	lines[cursor_idx] = lines[cursor_idx] .. "  -- << cursor here"
	return table.concat(lines, "\n")
end

--- Fetch the LSP hover text for the current cursor position without opening
--- any floating window. Calls `callback(text_or_nil)` on the main thread.
---
---@param bufnr integer
---@param callback fun(hover_text: string|nil)
local function get_hover_text(bufnr, callback)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		callback(nil)
		return
	end
	-- Use the first client's offset encoding to build correct params
	local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)
	vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result)
		if err or not (result and result.contents) then
			callback(nil)
			return
		end
		-- convert_input_to_markdown_lines handles all five LSP content shapes
		local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		-- Strip blank lines to keep the type signature compact
		local trimmed = {}
		for _, line in ipairs(lines) do
			if line:match("%S") then
				table.insert(trimmed, line)
			end
		end
		callback(#trimmed > 0 and table.concat(trimmed, "\n") or nil)
	end)
end

--- Build the prompt that is sent to the model, combining the symbol name,
--- filetype, LSP type info, and surrounding code context.
---
---@param word string
---@param ft string
---@param hover_text string|nil
---@param code_context string
---@return string
local function build_prompt(word, ft, hover_text, code_context)
	local parts = {
		string.format("I am renaming the identifier `%s` in a %s file.", word, ft),
	}
	if hover_text then
		table.insert(parts, string.format("Its type/signature from the language server is:\n%s", hover_text))
	end
	table.insert(parts, string.format("Here is the surrounding code:\n```%s\n%s\n```", ft, code_context))
	table.insert(
		parts,
		"Suggest 6 alternative names for this identifier that are clear, idiomatic, and fit the context. "
			.. "Reply with only a newline-separated list of names. No explanation, no numbers, no bullets."
	)
	return table.concat(parts, "\n\n")
end

--- Exchange the stored OAuth token for a short-lived Copilot session token,
--- then POST to the chat completions endpoint and return the raw response body
--- to `callback(session_token_or_nil)`.
---
---@param oauth_token string
---@param callback fun(session_token: string|nil)
local function get_session_token(oauth_token, callback)
	vim.system({
		"curl",
		"-s",
		"https://api.github.com/copilot_internal/v2/token",
		"-H",
		"Authorization: token " .. oauth_token,
		"-H",
		"Accept: application/json",
	}, { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify("Copilot: token exchange failed", vim.log.levels.WARN)
				callback(nil)
				return
			end
			local data = vim.json.decode(res.stdout)
			callback(data and data.token or nil)
		end)
	end)
end

--- Call the Copilot chat completions endpoint and return the assistant message
--- content to `callback(content_or_nil)`.
---
---@param session_token string
---@param prompt string
---@param callback fun(content: string|nil)
local function call_copilot(session_token, prompt, callback)
	local body = vim.json.encode({
		model = MODEL,
		messages = {
			{ role = "system", content = "You are a helpful coding assistant and an expert at naming variables." },
			{ role = "user", content = prompt },
		},
		max_tokens = 150,
		temperature = 0.8,
	})
	local ver = vim.version()
	vim.system({
		"curl",
		"-s",
		"https://api.githubcopilot.com/chat/completions",
		"-H",
		"Authorization: Bearer " .. session_token,
		"-H",
		"Content-Type: application/json",
		"-H",
		"Editor-Version: Neovim/" .. ver.major .. "." .. ver.minor .. "." .. ver.patch,
		"-H",
		"Copilot-Integration-Id: vscode-chat",
		"-d",
		body,
	}, { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify("Copilot: chat request failed (curl error " .. res.code .. ")", vim.log.levels.WARN)
				callback(nil)
				return
			end
			local ok, decoded = pcall(vim.json.decode, res.stdout)
			if not ok or not decoded then
				vim.notify("Copilot: failed to decode response: " .. tostring(res.stdout), vim.log.levels.WARN)
				callback(nil)
				return
			end
			-- Surface API-level errors (e.g. unsupported model, auth failure)
			if decoded.error then
				local msg = (type(decoded.error) == "table" and decoded.error.message) or tostring(decoded.error)
				vim.notify("Copilot API error: " .. msg, vim.log.levels.WARN)
				callback(nil)
				return
			end
			local content = decoded.choices
				and decoded.choices[1]
				and decoded.choices[1].message
				and decoded.choices[1].message.content
			callback(content or nil)
		end)
	end)
end

--- Parse the raw newline-separated response from the model into a list of
--- valid identifier strings.
---
---@param raw string
---@return string[]
local function parse_suggestions(raw)
	local suggestions = {}
	for line in raw:gmatch("[^\n]+") do
		local name = line:match("^%s*`?([%w_][%w_%d]*)`?%s*$")
		if name and name ~= "" then
			table.insert(suggestions, name)
		end
	end
	return suggestions
end

--- Entry point. Reads the word under the cursor, gathers context, asks
--- Copilot for name suggestions, then opens a vim.ui.select menu and
--- renames via LSP on confirmation. Safe to call with no arguments.
function M.suggest()
	local bufnr = vim.api.nvim_get_current_buf()
	local word = vim.fn.expand("<cword>")
	local filetype = vim.bo[bufnr].filetype

	if word == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end
	local auth_ok, auth = pcall(require, "copilot.auth")
	if not auth_ok then
		vim.notify("Copilot not available", vim.log.levels.WARN)
		return
	end

	local creds = auth.get_creds()
	if not creds then
		vim.notify("Copilot: not signed in", vim.log.levels.WARN)
		return
	end

	local oauth_token
	for _, entry in pairs(creds) do
		if entry.oauth_token then
			oauth_token = entry.oauth_token
			break
		end
	end
	if not oauth_token then
		vim.notify("Copilot: no oauth_token found", vim.log.levels.WARN)
		return
	end

	local ft = filetype ~= "" and filetype or "code"
	local cursor = vim.api.nvim_win_get_cursor(0)
	local code_context = get_buffer_context(bufnr, cursor)

	vim.notify("Asking Copilot for name suggestions…", vim.log.levels.INFO)

	-- Gather LSP hover text first, then fire the Copilot request with full context
	get_hover_text(bufnr, function(hover_text)
		local prompt = build_prompt(word, ft, hover_text, code_context)

		get_session_token(oauth_token, function(session_token)
			if not session_token then
				vim.notify("Copilot: could not get session token", vim.log.levels.WARN)
				return
			end

			call_copilot(session_token, prompt, function(raw)
				if not raw then
					vim.notify("Copilot: no suggestions returned", vim.log.levels.WARN)
					return
				end

				local suggestions = parse_suggestions(raw)
				if #suggestions == 0 then
					vim.notify("Copilot: no valid identifiers in response", vim.log.levels.WARN)
					return
				end

				vim.ui.select(suggestions, {
					prompt = "Rename `" .. word .. "` to:",
				}, function(choice)
					if choice then
						vim.lsp.buf.rename(choice)
					end
				end)
			end)
		end)
	end)
end

return M
