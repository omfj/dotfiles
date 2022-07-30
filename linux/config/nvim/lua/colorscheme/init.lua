local colorscheme = "jellybeans"

if colorscheme == "tokyonight" then
    vim.g.tokyonight_style = "night"
end

if colorscheme == "monokaipro" then
    vim.g.monokaipro_filter = "spectrum"
    vim.g.monokaipro_italic_functions = true
end


local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found!")
    return
end

