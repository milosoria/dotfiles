local function init()

    --Alt moving lines
    vim.api.nvim_set_keymap('n','<A-j>',':m .+1<CR>==', {noremap=true})
    vim.api.nvim_set_keymap('n','<A-k>',':m .-2<CR>==', {noremap=true})
    vim.api.nvim_set_keymap('n','<A-j>',":m '>+1<CR>gv=gv", {noremap=true})
    vim.api.nvim_set_keymap('n','<A-k>',":m '<-2<CR>gv=gv", {noremap=true})
    --Resizing
    vim.api.nvim_set_keymap('n','<leader>+',':vertical :resize +20<CR>', {noremap=true})
    vim.api.nvim_set_keymap('n','<leader>-',':vertical :resize -20<CR>', {noremap=true})
    vim.api.nvim_set_keymap('n','<leader>=','<C-W>= <CR>', {noremap=true})
    --
    --Easier moving between splits
    vim.api.nvim_set_keymap('n','<C-J>','<C-W><C-J>', {noremap=true})
    vim.api.nvim_set_keymap('n','<C-K>','<C-W><C-K>', {noremap=true})
    vim.api.nvim_set_keymap('n','<C-H>','<C-W><C-H>', {noremap=true})
    vim.api.nvim_set_keymap('n','<C-L>','<C-W><C-L>', {noremap=true})

    --Indenting with builtin
    vim.api.nvim_set_keymap('n','<leader>i','ma :norm gg=G<CR> `a', {noremap=true})
    -- Remap C-W C-O to <leader>w
    vim.api.nvim_set_keymap('n', '<Leader>w', '<C-W><C-O>', { noremap = true})
    -- remap to indent with one keystroke
    vim.api.nvim_set_keymap('n', '>', '>>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<', '<<', { noremap = true})
    -- remap to force quit
    vim.api.nvim_set_keymap('n', '<Leader>q', ':q!<CR>', { noremap = true})
    -- terminal escape keys
    vim.api.nvim_set_keymap('t','<Esc>','<C-\\><C-n>',{noremap=true})
end

return {
    init=init
}
