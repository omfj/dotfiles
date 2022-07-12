local colorscheme = "tokyonight"

if colorscheme == "tokyonight" then
    vim.g.tokyonight_style = "night"
end

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found!")
    return
end

