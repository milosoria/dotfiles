"Key maps and shortcuts

" leader key definition <space>
let mapleader = " "

"Alt moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Resizing
nnoremap <leader>+ :vertical :resize +10<CR>
nnoremap <leader>- :vertical :resize -10<CR>
nnoremap <leader>= <C-W>= <CR>

" Terminal remap
tnoremap <Esc> <C-\><C-n>

" Easier moving between splits
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-H> <C-W><C-H>
noremap <C-L> <C-W><C-L>

" Indenting with builtin
nnoremap <leader>i ma :norm gg=G<CR> `a  

" Remap C-W C-O to <leader>w
nnoremap <leader>w <C-W><C-O>

" remap to indent with one >
nnoremap > >>
nnoremap < <<

" remap to force quit
nnoremap <leader>q :q!<CR>

" visual to end of line
nnoremap vv v$
nnoremap [ [m
nnoremap ] ]m
