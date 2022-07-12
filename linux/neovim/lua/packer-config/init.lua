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

    -- LSP
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"

    -- Telescope
    use "nvim-telescope/telescope.nvim"

    -- CMP
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"

    -- LSP

    -- Diagnostics
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    -- Pairing brackets and so on
    use {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- COC (for coc-rust-analyzer)
    use { "neoclide/coc.nvim", branch = "release" }

    -- Code formating
    use "jose-elias-alvarez/null-ls.nvim"
    use {
        "prettier/vim-prettier",
        run = "yarn install",
    }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- Colorschemes
    use "lunarvim/colorschemes"
    use "RRethy/nvim-base16"
    use "folke/tokyonight.nvim"

    -- File explorer
    use "preservim/nerdtree"

end)
