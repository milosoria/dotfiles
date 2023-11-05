--Plugins added via plugged, plug manager
local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.vim/plugged")
-- completion
-- Plugs
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
-- main
Plug("hrsh7th/nvim-cmp")
-- snips completion
Plug("L3MON4D3/LuaSnip")
Plug("saadparwaiz1/cmp_luasnip")
Plug("rafamadriz/friendly-snippets")
-- Lsp icons
Plug("onsails/lspkind-nvim")
-- Main reason for slow startup
Plug("tzachar/cmp-tabnine", {
    ["do"] = function()
        vim.cmd("./install.sh")
    end,
})
-- Telescope
Plug("nvim-lua/popup.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", {
    ["do"] = function()
        vim.cmd("make")
    end,
})

-- LSP
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("neovim/nvim-lspconfig")

-- tresitter
Plug("nvim-treesitter/nvim-treesitter", {
    ["do"] = function()
        vim.cmd(":TSUpdate")
    end,
})
-- indent line symbol
Plug("lukas-reineke/indent-blankline.nvim")
-- COLORSCHEMES
-- tokyonight
Plug("folke/tokyonight.nvim")
-- gruvbox
Plug("rktjmp/lush.nvim")
Plug("ellisonleao/gruvbox.nvim")
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
-- -- toggle terminal
Plug("caenrique/nvim-toggle-terminal")
-- lua line
Plug("hoob3rt/lualine.nvim")
-- comments
Plug("tpope/vim-commentary")
-- format
Plug("sbdchd/neoformat")
-- devicons and nvim-tree
Plug("kyazdani42/nvim-tree.lua")
Plug("kyazdani42/nvim-web-devicons")
--- AutoPairs, AutoTags
Plug("windwp/nvim-autopairs")
Plug("windwp/nvim-ts-autotag")
-- LSPSaga Uis
Plug("glepnir/lspsaga.nvim")
-- Tab bar
-- Plug("nanozuki/tabby.nvim")
Plug("romgrk/barbar.nvim")
-- Colorizer
Plug("norcalli/nvim-colorizer.lua")
-- Copilot
Plug("github/copilot.vim")
-- Vim maximizer
Plug("szw/vim-maximizer")
-- Null-ls linters and formatters
Plug("jose-elias-alvarez/null-ls.nvim")
Plug("jayp0521/mason-null-ls.nvim")
Plug("lukas-reineke/lsp-format.nvim")
Plug("christoomey/vim-tmux-navigator")
vim.call("plug#end")

-- run specific config for markdown
vim.cmd([[
autocmd FileType markdown set textwidth=0
autocmd FileType text set textwidth=0
]])

-- Yank highlight
vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=150}
augroup END
]])

--source every config file
require("init")
