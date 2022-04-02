local function init()
    vim.api.nvim_set_keymap('n', '<Leader>tn', ':ToggleTerminal<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>tv', ':vsplit | :ToggleTerminal<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>th', ':split | :ToggleTerminal<CR>', { noremap = true})
    vim.g.open_in_insert_mode=1
    vim.g.preserve_alternate_buffer=1
end

return {
    init=init
}
