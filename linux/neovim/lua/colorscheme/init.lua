local colorscheme = "tomorrow"

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found!")
    return
end

