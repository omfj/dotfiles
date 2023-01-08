-- Vim settings

local options = {
    expandtab = true,
    smarttab = true,
    shiftwidth = 4,
    tabstop = 4,
    hlsearch = true,
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    splitbelow = true,
    splitright = true,
    wrap = false,
    scrolloff = 7,
    fileencoding = "utf-8",
    termguicolors = true,
    relativenumber = true,
    number = true,
    cursorline = true,
    mouse = "a",
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

