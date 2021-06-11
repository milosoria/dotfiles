set cmdheight=1
set eadirection="ver"
set wildmode=longest,full
set wildmenu
set relativenumber
set shell=/usr/bin/zsh
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set shiftwidth=4
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
set scrolloff=8
set signcolumn=yes
set completeopt=menuone,noinsert,noselect
set termguicolors
"Plugins added via plugged
call plug#begin('~/.vim/plugged')
    Plug 'nvim-lua/completion-nvim'
    Plug 'sbdchd/neoformat'
    Plug 'neovim/nvim-lsp'
    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'honza/vim-snippets'
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
    Plug 'sudormrfbin/cheatsheet.nvim'
    Plug 'SirVer/ultisnips'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'gennaro-tedesco/nvim-commaround'
    Plug 'ntk148v/vim-horizon'
call plug#end()
" Enable snippets
let g:completion_enable_snippet = 'UltiSnips'
" Neo format run all formatters
let g:neoformat_run_all_formatters = 1
"Lsp servers configed
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
lua << EOF
require'nvim-web-devicons'.setup {
 default = true;
}
EOF
lua << EOF
-- require('telescope').load_extension('media_files')
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
        'rg -u',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
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
    file_ignore_patterns = {},
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    results_height = 1,
    preview_cutoff = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
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
require('telescope').load_extension('fzy_native')
EOF
lua << EOF
require'lualine'.setup{options={theme='horizon',component_separators = {'', ''},
    section_separators = {'', ''}, }, sections = {lualine_a = {'mode', 'branch', 'filename'}}}
EOF
"Colorscheme configs
colorscheme gruvbox 
highlight Normal guibg=none
" let g:lightline = {'colorscheme' : 'horizon'}
" let g:horizon_transp_bg ="1" 
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[39;2;%lu;%lu;lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu:lum"
endif
"tresitter for highlighting
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, ensure_installed = "maintained"}
"completion strategy 
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"key maps and shortcuts
let mapleader = " "
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
nnoremap <leader> gd <cmd>lua vim.lsp.buf.declaration()<CR>
vmap <leader>c <Plug>ToggleCommaround
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
noremap pumvisible() ? "\" : " "
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap <leader>f <cmd>Telescope live_grep <CR>
nnoremap <leader>b <cmd>Telescope buffers<CR>
nnoremap <C-p> <cmd>Telescope find_files <CR>
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
