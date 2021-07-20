"Plugins added via plugged, plug manager
call plug#begin('~/.vim/plugged')
" completion
Plug 'nvim-lua/completion-nvim'
Plug 'aca/completion-tabnine', { 'do': './install.sh' }
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
Plug 'Yggdroot/indentLine'

" Colorscheme tokyonight
Plug 'folke/tokyonight.nvim'

" lua line
Plug 'hoob3rt/lualine.nvim'

" comments
Plug 'tpope/vim-commentary'

" float term
Plug 'voldikss/vim-floaterm'

" format
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'sbdchd/neoformat'

" Plug 'sbdchd/neoformat'
Plug 'ludovicchabant/vim-gutentags'

" devicons and nvim-tree
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

"Tab nine, lsp, snip
let g:completion_chain_complete_list = {
            \ 'default': [
                \    {'complete_items': ['lsp', 'snippet', 'tabnine' ]},
                \]
                \}
lua require('luasnip.config')._setup()

"completion strategy
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Auto group format
augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat | Prettier
augroup END
" autocmd for not continuing comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=o

" Yank highlight
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" indent plug
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" devicons setup
lua << EOF
require'nvim-web-devicons'.setup {
    default = true;
    }
EOF

" gutentags
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_write = 1

"source every config file
source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim
luafile ~/.config/nvim/lua/init.lua
