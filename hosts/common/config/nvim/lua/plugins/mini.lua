return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          update_n_lines = "sn",
        },
      })
      
      require("mini.pairs").setup()
      
      require("mini.comment").setup()
      
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })
      
      require("mini.move").setup()
      
      require("mini.ai").setup()
      
      require("mini.hipatterns").setup({
        highlighters = {
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      })
    end,
  },
}