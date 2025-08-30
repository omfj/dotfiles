return {
    {
        "aktersnurra/no-clown-fiesta.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "Mofiqul/vscode.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("vscode").setup({
                italic_comments = true,
            })
        end,
    },
}
