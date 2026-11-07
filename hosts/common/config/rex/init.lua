local P = "ctrl+a>"
local SHELL = "com.superlogical.terminal.shell"

-- Like tmux #{pane_current_path}; pwd comes back as file://host/path
local function pane_cwd(ctx)
	if not ctx.block_id then
		return nil
	end
	local r = rex.block.call("com.superlogical.terminal", "pwd", { block_id = ctx.block_id })
	if not r or not r.pwd then
		return nil
	end
	local path = r.pwd:gsub("^file://[^/]*", "")
	return (path:gsub("%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end))
end

local function shell(ctx, command)
	return rex.layout.block({ flavor = SHELL, options = { cwd = pane_cwd(ctx), command = command } })
end

local function check(result, err)
	if err then
		error(err, 0)
	end
	return result
end

local function split_action(name, title, direction)
	rex.action({
		name = name,
		title = title,
		run = function(ctx)
			check(rex.session.new_split({
				anchor_id = ctx.block_id,
				direction = direction,
				side = "after",
				focus = true,
				layout = shell(ctx),
			}))
		end,
	})
end
split_action("split_right_here", "Split Right (Current Dir)", "horizontal")
split_action("split_down_here", "Split Down (Current Dir)", "vertical")

local function popup_action(name, title, cmd)
	rex.action({
		name = name,
		title = title,
		run = function(ctx)
			check(rex.session.new_layer({
				bounds = { 0.04, 0.04, 0.92, 0.92 },
				focus = true,
				layout = shell(ctx, cmd),
			}))
		end,
	})
end
popup_action("popup_lazygit", "Popup: lazygit", { "lazygit" })
popup_action("popup_todo", "Popup: todo", { "todo" })
popup_action("popup_btop", "Popup: btop", { "btop" })

rex.bind(P .. "ctrl+a", "pane.send_key", { key = "ctrl+a" })

rex.bind(P .. "alt+7", "split_right_here")
rex.bind(P .. "-", "split_down_here")

rex.bind(P .. "h", "pane.focus.left")
rex.bind(P .. "j", "pane.focus.down")
rex.bind(P .. "k", "pane.focus.up")
rex.bind(P .. "l", "pane.focus.right")

-- Stand-in for tmux `bind -r`: C-a C-h resizes once, then h/j/k/l keep going until Esc
rex.action({
	name = "resize_and_enter_mode",
	title = "Resize Pane (Enter Resize Mode)",
	args = { direction = "string" },
	run = function(_, args)
		rex.client.queue("pane.resize", { direction = args.direction, amount = 2 })
		rex.client.queue("client.mode.enter", { name = "resize" })
	end,
})

rex.mode("resize", { exclusive = true })
rex.bind(P .. "shift+r", "client.mode.enter", { name = "resize" })
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind(P .. "ctrl+" .. key, "resize_and_enter_mode", { direction = dir })
	rex.bind("resize/" .. key, "pane.resize", { direction = dir, amount = 2 })
	rex.bind("resize/ctrl+" .. key, "pane.resize", { direction = dir, amount = 2 })
	rex.bind("resize/shift+" .. key, "pane.resize", { direction = dir, amount = 10 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/q", "client.mode.exit")

rex.bind(P .. "shift+h", "pane.move.left")
rex.bind(P .. "shift+j", "pane.move.down")
rex.bind(P .. "shift+k", "pane.move.up")
rex.bind(P .. "shift+l", "pane.move.right")

rex.bind(P .. "shift+=", "session.new")

rex.bind(P .. ",", "client.tab.rename")
rex.bind(P .. ".", "session.rename")

rex.bind(P .. "r", "client.config.reload")

rex.bind(P .. "g", "popup_lazygit")
rex.bind(P .. "o", "popup_todo")
rex.bind(P .. "b", "popup_btop")

rex.bind(P .. "m", "client.palette.toggle")

-- tmux defaults
rex.bind(P .. "x", "pane.close")
rex.bind(P .. "s", "session.switch")
for i = 1, 9 do
	rex.bind(P .. tostring(i), "client.tab.goto", { index = i })
end
