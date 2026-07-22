# My Neovim config

Uses `vim.pack`, the built-in package manager.

Plugin revisions are pinned in `nvim-pack-lock.json`. To intentionally update
them, run `:lua vim.pack.update()` in Neovim and commit the resulting lockfile.

## Structure

- `init.lua` — loader, neovide settings
- `lua/config/` — options, keymaps, autocmds
- `plugin/` — one file per plugin or category. Numbered files load first, in alphabetical order.
  - `00-pack-hooks.lua` — package install/update hooks (Mason, Treesitter, Blink)
  - `01-colorscheme.lua` — loaded early so UI picks up correct highlights
  - remaining files — plugin configuration
- `lsp/` — per-server LSP overrides; servers are installed and enabled from `plugin/lsp.lua`
