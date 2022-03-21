--Plugins added via plugged, plug manager
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.vim/plugged')
-- completion
-- main
Plug('hrsh7th/nvim-cmp')
-- Plugs
Plug('hrsh7th/cmp-nvim-lsp')
Plug( 'hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
-- snips completion
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')
-- Lsp icons
Plug('onsails/lspkind-nvim')
-- Main reason for slow startup
Plug('tzachar/cmp-tabnine', {['do']=
    function()
        vim.cmd('./install.sh')
    end
})
-- Telescope
Plug('nvim-lua/popup.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do']=
    function()
        vim.cmd('make')
    end
})
-- LSP
Plug('williamboman/nvim-lsp-installer')
Plug('neovim/nvim-lspconfig')
-- tresitter
Plug('nvim-treesitter/nvim-treesitter', {['do']=
    function()
        vim.cmd(':TSUpdate')
    end
})
-- indent line symbol
Plug('Yggdroot/indentLine')
-- COLORSCHEMES
-- tokyonight
Plug('folke/tokyonight.nvim')
-- gruvbox
-- Plug 'rktjmp/lush.nvim'
-- Plug 'ellisonleao/gruvbox.nvim'
-- Color for lualine
Plug('drewtempelmeyer/palenight.vim')
-- -- toggle terminal
Plug('caenrique/nvim-toggle-terminal')
-- lua line
Plug('hoob3rt/lualine.nvim')
-- comments
Plug('tpope/vim-commentary')
-- format
Plug('sbdchd/neoformat')
-- devicons and nvim-tree
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
--- AutoPairs
Plug('jiangmiao/auto-pairs')
vim.call('plug#end')

-- run specific config for markdown
vim.cmd [[
    autocmd FileType markdown set textwidth=0
    autocmd FileType text set textwidth=0
]]
-- bg to none so winseparator shows only a thin line
vim.cmd [[
    highlight winseparator guibg=None
]]
-- Yank highlight
vim.cmd [[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=150}
    augroup END
]]

--source every config file
require'init'
