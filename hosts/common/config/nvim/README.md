# My Neovim config

Uses `vim.pack`, the built-in package manager.

## Structure

- `init.lua` — loader, neovide settings
- `lua/config/` — options, keymaps, autocmds
- `plugin/` — one file per plugin / category. some are prefix with numbers because they are sourced in alphabetical order.
  - `00-pack-hooks.lua` — build hooks (fzf-native, LuaSnip, mason, treesitter)
  - `01-colorscheme.lua` — loaded early so UI picks up correct highlights
  - ... rest are plugins that can be loaded in any order.
