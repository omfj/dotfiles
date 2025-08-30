return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>ft", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
    { "<leader>fT", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
    { "<c-/>", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
    { "<c-_>", "<cmd>ToggleTerm direction=float<cr>", desc = "which_key_ignore" },
  },
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })
  end,
}