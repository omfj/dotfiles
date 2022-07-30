-- Incase packer fails
local ok, packer = pcall(require, "packer")
if not ok then
    vim.notify("Could not load plugins!")
end

-- Packer use popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Plugins here
return packer.startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Nvim stuff
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    -- Telescope
    use "nvim-telescope/telescope.nvim"

    -- Diagnostics
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    -- Code lens
    use 'markwoodhall/vim-codelens'

    -- Pairing brackets and so on
    use {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- COC (for coc-rust-analyzer)
    use { "neoclide/coc.nvim", branch = "release" }

    -- Lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use {
        'kdheepak/tabline.nvim',
        requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
    }

    -- Floating terminal
    use 'voldikss/vim-floaterm'

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- Colorschemes
    use 'https://gitlab.com/__tpb/monokai-pro.nvim'
    use "nanotech/jellybeans.vim"

    -- File explorer
    use "preservim/nerdtree"

end)
