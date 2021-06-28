"Editor configs
set cmdheight=1
set eadirection="ver"
set wildmode=longest,full
set wildmenu
set relativenumber
set shell=/bin/zsh
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set nowrap
set expandtab
set textwidth=80
set smartindent
set nu
set nohlsearch
set hidden
set noerrorbells
set smartcase
set ignorecase
set noswapfile
set incsearch
set guicursor=a:blinkon80
set scrolloff=8
set signcolumn=yes
set completeopt=menuone,noinsert,noselect
set numberwidth=3
set signcolumn=auto
set termguicolors
"set highlight c:
highlight clear SignColumn

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
" Plug 'honza/vim-snippets'
"Plug 'codota/tabnine-vim'
" Plug 'preservim/nerdtree'
call plug#end()


let g:neoformat_only_msg_on_error = 0
" Neo format run all formatters
let g:neoformat_run_all_formatters = 1
" Enable alignment globally
let g:neoformat_basic_format_align = 1

" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1
"Lsp servers setup
lua << EOF
require'lspinstall'.setup() -- important
local servers = require'lspinstall'.installed_servers()
local capabilities = vim.lsp.protocol.make_client_capabilities()
for _, server in pairs(servers) do
    if server == 'cpp' then
        require'lspconfig'[server].setup{capabilities=capabilities, on_attach=require'completion'.on_attach,default_config= { filetypes={'c', 'objc'}}}
    else
        require'lspconfig'[server].setup{capabilities=capabilities,on_attach=require'completion'.on_attach}
    end
end
EOF

" devicons setup
lua << EOF
require'nvim-web-devicons'.setup {
    default = true;
    }
EOF

" Telescope setup
lua << EOF
require('telescope').load_extension('media_files')
require('telescope').load_extension('fzy_native')
require('telescope').setup{
defaults = {
    vimgrep_arguments = {
        'rg',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
        },
    file_ignore_patterns = {"./node_modules/*", "node_modules", "^node_modules/*", "node_modules/*", "./yarn.*", "yarn.*"},
    prompt_position = "bottom",
    selection_caret = "> ",
    prompt_prefix = "🔍 ",
entry_prefix = "  ",
initial_mode = "insert",
selection_strategy = "reset",
sorting_strategy = "descending",
layout_strategy = "horizontal",
layout_defaults = {
    horizontal = {
        mirror = false,
        },
    vertical = {
        mirror = false,
        },
    },
file_sorter =  require'telescope.sorters'.get_fzy_sorter,
color_devicons = true,
shorten_path = true,
winblend = 0,
width = 0.75,
results_height = 1,
preview_cutoff = 1,
results_width = 0.8,
border = {},
borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
use_less = true,
file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
extensions ={
fzy_native = {
    override_generic_sorter = false,
    override_file_sorter =true,
    }
},
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}
EOF
"Tab nine, lsp, snip
let g:completion_chain_complete_list = {
            \ 'default': [
                \    {'complete_items': ['lsp', 'snippet', 'tabnine' ]},
                \]
                \}

" Enable snippets UtilSnips and mapping
let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsExpandTrigger="<space>"
let g:ulti_expand_or_jump_res = 0
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsExpandTrigger="<nop>"
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction

" Lualine setup
lua << EOF
require'lualine'.setup{options={theme='horizon',component_separators = {'', ''},
section_separators = {'', ''}, }, sections = {lualine_a = {'mode', 'branch', 'filename'}}}
EOF

"Colorscheme configs
colorscheme tokyonight
let g:tokyonight_style = "night"
let g:tokyonight_italic_functions =1
let g:tokyonight_transparent_background =1
" colorscheme gruvbox
" highlight Normal guibg=none
" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_invert_selection='0'
" if exists('+termguicolors')
"     let &t_8f = "\<Esc>[39;2;%lu;%lu;lum"
"     let &t_8b = "\<Esc>[48;2;%lu;%lu:lum"
" endif

"tresitter for highlighting
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, ensure_installed = "maintained"}

"completion strategy
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

"Key maps and shortcuts

" leader key definition <space>
let mapleader = " "

nnoremap <leader> gd <cmd>lua vim.lsp.buf.declaration()<CR>
vmap <leader>c <Plug>ToggleCommaround
"Alt moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Completion remap for tab and enter
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"
noremap pumvisible() ? "\" : " "
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Telescope
nnoremap <leader>f <cmd>Telescope live_grep <CR>
nnoremap <C-b> <cmd>Telescope buffers<CR>
nnoremap <C-p> <cmd>Telescope find_files hidden=true <CR>
" Resizing
nnoremap <leader>e :wincmd v<bar> :Ex <bar> :vertical resize 30 <CR>
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

"terminal remap
tnoremap <Esc> <C-\><C-n>

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

" indent plug
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" Float Term
nnoremap   <leader>t :FloatermToggle<CR>
" nnoremap   <ESC><ESC> :FloatermToggle <CR>
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
