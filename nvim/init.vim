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
Plug 'ghifarit53/tokyonight-vim'
Plug 'SirVer/ultisnips'
Plug 'hoob3rt/lualine.nvim'
Plug 'gennaro-tedesco/nvim-commaround'
Plug 'ntk148v/vim-horizon'
Plug 'ludovicchabant/vim-gutentags'
Plug 'aca/completion-tabnine', { 'do': './install.sh' }
" Plug 'preservim/nerdtree'
call plug#end()


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
default = true;
require'nvim-web-devicons'.setup {
    }
EOF

"source every config file
" SHOULD I PORT THIS TO LUA???
source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim

for f in split(glob('~/.config/nvim/plugins/**'), '\n')
    exe 'source' f
endfor
