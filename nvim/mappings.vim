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

"terminal remap
tnoremap <Esc> <C-\><C-n>

" Float Term
nnoremap   <leader>t :FloatermToggle<CR>

" Easier moving between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

