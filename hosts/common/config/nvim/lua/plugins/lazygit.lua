return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "crnvl96/lazydocker.nvim",
    keys = {
      { "<leader>gd", function() require("lazydocker").toggle({ engine = "docker" }) end, desc = "LazyDocker" },
    },
    config = function()
      require("lazydocker").setup({
        window = {
          settings = {
            width = 0.8,
            height = 0.8,
            border = "rounded",
            relative = "editor",
          },
        },
      })
    end,
  },
}
