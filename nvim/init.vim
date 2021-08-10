"Plugins added via plugged, plug manager
call plug#begin('~/.vim/plugged')

" completion
Plug 'hrsh7th/nvim-compe'
Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
Plug 'L3MON4D3/LuaSnip'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" LSP
Plug 'kabouzeid/nvim-lspinstall'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'

" tresitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

"indent line symbol
Plug 'Yggdroot/indentLine'

" Colorscheme tokyonight
Plug 'folke/tokyonight.nvim'

" toggle terminal
Plug 'caenrique/nvim-toggle-terminal'

" lua line
Plug 'hoob3rt/lualine.nvim'

" comments
Plug 'tpope/vim-commentary'

" format
Plug 'sbdchd/neoformat'

" devicons and nvim-tree
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

" run specific config for markdown
autocmd FileType markdown set textwidth=0
autocmd FileType text set textwidth=0

"Prettier
let g:prettier#autoformat_require_pragma = 0
let g:prettier#quickfix_enabled = 0

" autocmd for not continuing comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=o

" Yank highlight
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}

" indent plug
let g:indentLine_char_list = ['|', '¦', '┆', '┊']


"source every config file
source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim
luafile ~/.config/nvim/lua/init.lua
