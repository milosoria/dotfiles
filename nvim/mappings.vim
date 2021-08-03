"Key maps and shortcuts

" leader key definition <space>
let mapleader = " "

"Alt moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" " Completion remap for tab and enter
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')

" Telescope
nnoremap <leader>f <cmd>Telescope live_grep <CR>
nnoremap <C-b> <cmd>Telescope buffers<CR>
nnoremap <C-p> <cmd>Telescope find_files hidden=true <CR>

" Resizing
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

" Terminal remap
tnoremap <Esc> <C-\><C-n>

" Float Term
nnoremap <leader>t :FloatermToggle<CR>

" Easier moving between splits
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-H> <C-W><C-H>
noremap <C-L> <C-W><C-L>

" Indenting with builtin
nnoremap <leader>i :norm gg=G <CR>
