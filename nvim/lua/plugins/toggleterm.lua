local function init()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
    vim.g.auto_start_insert =0
end

return {
    init=init
}
