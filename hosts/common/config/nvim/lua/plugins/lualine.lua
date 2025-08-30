return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local kanagawa_colors = require("kanagawa.colors").setup({ theme = "dragon" })
        local colors = kanagawa_colors.palette
        local kanagawa_dragon = {
            normal = {
                a = { bg = colors.dragonBlue, fg = colors.dragonBlack0, gui = "bold" },
                b = { bg = colors.dragonBlack4, fg = colors.dragonWhite },
                c = { bg = colors.dragonBlack1, fg = colors.dragonWhite },
            },
            insert = {
                a = { bg = colors.dragonGreen, fg = colors.dragonBlack0, gui = "bold" },
                b = { bg = colors.dragonBlack4, fg = colors.dragonWhite },
            },
            visual = {
                a = { bg = colors.dragonOrange, fg = colors.dragonBlack0, gui = "bold" },
                b = { bg = colors.dragonBlack4, fg = colors.dragonWhite },
            },
            replace = {
                a = { bg = colors.dragonRed, fg = colors.dragonBlack0, gui = "bold" },
                b = { bg = colors.dragonBlack4, fg = colors.dragonWhite },
            },
            command = {
                a = { bg = colors.dragonViolet, fg = colors.dragonBlack0, gui = "bold" },
                b = { bg = colors.dragonBlack4, fg = colors.dragonWhite },
            },
            inactive = {
                a = { bg = colors.dragonBlack1, fg = colors.dragonWhite, gui = "bold" },
                b = { bg = colors.dragonBlack1, fg = colors.dragonWhite },
                c = { bg = colors.dragonBlack1, fg = colors.dragonWhite },
            },
        }

        require("lualine").setup({
            options = {
                theme = kanagawa_dragon,
                globalstatus = true,
            },
        })
    end,
}
