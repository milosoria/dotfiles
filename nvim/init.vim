"Plugins added via plugged, aka plug manager
call plug#begin('~/.vim/plugged')
Plug 'voldikss/vim-floaterm'
Plug 'Yggdroot/indentLine'
Plug 'nvim-lua/completion-nvim'
Plug 'sbdchd/neoformat'
Plug 'neovim/nvim-lsp'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'gruvbox-community/gruvbox'
" Plug 'ghifarit53/tokyonight-vim'
Plug 'folke/tokyonight.nvim'
" Plug 'SirVer/ultisnips'
Plug 'hoob3rt/lualine.nvim'
Plug 'gennaro-tedesco/nvim-commaround'
Plug 'ntk148v/vim-horizon'
Plug 'ludovicchabant/vim-gutentags'
Plug 'aca/completion-tabnine', { 'do': './install.sh' }
Plug 'L3MON4D3/LuaSnip'
" Plug 'preservim/nerdtree'
call plug#end()

"LuaSnip
let g:snippets = 'LuaSnip'

"Tab nine, lsp, snip
let g:completion_chain_complete_list = {
            \ 'default': [
                \    {'complete_items': ['lsp', 'snippet', 'tabnine' ]},
                \]
                \}

"completion strategy
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Auto group format
augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup END

" Yank highlight
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}

" open Nerdtree when vim opens
" nnoremap <C-n> :NERDTreeToggle<CR>
" let g:NERDTreeDirArrowExpandable = '▸'
" let NERDTreeShowHidden=1
" let g:NERDTreeDirArrowCollapsible = '▾'
" let g:NERDTreeGitStatusWithFlags = 1
" let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')
"
" indent plug
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" devicons setup
lua << EOF
require'nvim-web-devicons'.setup {
    default = true;
    }
EOF
"gutentags
let g:gutentags_ctags_exclude = [
            \ '*.git', '*.svg', '*.hg',
            \ '*/tests/*',
            \ 'build',
            \ 'dist',
            \ '*sites/*/files/*',
            \ 'bin',
            \ 'node_modules',
            \ 'bower_components',
            \ 'cache',
            \ 'compiled',
            \ 'docs',
            \ 'example',
            \ 'bundle',
            \ 'vendor',
            \ '*.md',
            \ '*-lock.json',
            \ '*.lock',
            \ '*bundle*.js',
            \ '*build*.js',
            \ '.*rc*',
            \ '*.json',
            \ '*.min.*',
            \ '*.map',
            \ '*.bak',
            \ '*.zip',
            \ '*.pyc',
            \ '*.class',
            \ '*.sln',
            \ '*.Master',
            \ '*.csproj',
            \ '*.tmp',
            \ '*.csproj.user',
            \ '*.cache',
            \ '*.pdb',
            \ 'tags*',
            \ 'cscope.*',
            \ '*.less',
            \ '*.scss',
            \ '*.exe', '*.dll',
            \ '*.mp3', '*.ogg', '*.flac',
            \ '*.swp', '*.swo',
            \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
            \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
            \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
            \ ]
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')

"source every config file
" SHOULD I PORT THIS TO LUA???
source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim
luafile ~/.config/nvim/lua/init.lua
