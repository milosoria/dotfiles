local function init()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
    -- vim.api.nvim_set_keymap('t', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
end

return {
    init=init
}
