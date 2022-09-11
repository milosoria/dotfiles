local function init()
    local settings = {
        noremap = true
    }
    --Alt moving lines
    vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', settings)
    vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', settings)
    vim.api.nvim_set_keymap('n', '<A-j>', ":m '>+1<CR>gv=gv", settings)
    vim.api.nvim_set_keymap('n', '<A-k>', ":m '<-2<CR>gv=gv", settings)
    --Resizing
    vim.api.nvim_set_keymap('n', '<leader>+', ':vertical resize +10<CR>', settings)
    vim.api.nvim_set_keymap('n', '<leader>-', ':vertical resize -10<CR>', settings)
    vim.api.nvim_set_keymap('n', '<leader>=', '<C-W>= <CR>', settings)
    --
    --Easier moving between splits
    vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', settings)
    vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', settings)
    vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', settings)
    vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', settings)

    --Indenting with builtin
    vim.api.nvim_set_keymap('n', '<leader>i', 'ma :norm gg=G<CR> `a', settings)
    -- Remap C-W C-O to <leader>w
    vim.api.nvim_set_keymap('n', '<Leader>w', '<C-W><C-O>', settings)
    -- remap to indent with one keystroke
    vim.api.nvim_set_keymap('n', '>', '>>', settings)
    vim.api.nvim_set_keymap('n', '<', '<<', settings)
    -- remap to force quit
    vim.api.nvim_set_keymap('n', '<leader>q', ':q!<CR>', settings)
    -- terminal escape keys
    vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', settings)
    -- tabs usage
    vim.api.nvim_set_keymap('n', '<leader>tn', ':tabe<CR>', settings)
    -- tab delete all but the current
    vim.api.nvim_set_keymap('n', '<leader>tc', ':tabc<CR>', settings)
    -- tab delete current
    vim.api.nvim_set_keymap('n', '<leader>td', ':tabonly<CR>', settings)
    -- next tab
    vim.api.nvim_set_keymap('n', '<leader>l', ':tabnext<CR>', settings)
    -- prev tab
    vim.api.nvim_set_keymap('n', '<leader>h', ':tabprev<CR>', settings)
    -- QuickFixList
    vim.api.nvim_set_keymap('n', '<leader>co', ':copen<CR>', settings)
    vim.api.nvim_set_keymap('n', '<leader>cn', ':cn<CR>', settings)
    vim.api.nvim_set_keymap('n', '<leader>cp', ':cp<CR>', settings)
    vim.api.nvim_set_keymap('n', '<leader>cq', ':ccl<CR>', settings)
    -- Close buffer without quitting it
    vim.api.nvim_set_keymap('n', '<leader>cc', ':close<CR>', settings)
    -- Paste and remove what just added
    vim.api.nvim_set_keymap('v', '<leader>p', '\"_dP', settings)
end

return {
    init = init
}
