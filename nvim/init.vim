"Plugins added via plugged, plug manager
call plug#begin('~/.vim/plugged')

" completion
" main
Plug 'hrsh7th/nvim-cmp'
" Plugs
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" snips completion
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" Lsp icons
Plug 'onsails/lspkind-nvim'

" Main reason for slow startup
" Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

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
Plug 'folke/tokyonight.nvim', {'branch':'main'}

" Color for lualine
Plug 'drewtempelmeyer/palenight.vim'

" toggle terminal
Plug 'caenrique/nvim-toggle-terminal'

" Auto close brackets and braces
Plug 'jiangmiao/auto-pairs'

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

" AutoPairs does dis even work?
let AutoPairs = {'[':']', '{':'}', "`":"`", '```':'```', '"""':'"""', "'''":"'''"}

autocmd FileType * setlocal formatoptions-=c formatoptions-=o

" Yank highlight
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}

" indent plug
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" Latex flavor, in order to make the FileType be a latex and not plaintex
let g:tex_flavor = "latex"

"source every config file
source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim
luafile ~/.config/nvim/lua/init.lua
