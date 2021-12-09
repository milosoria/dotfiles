local function init()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
    vim.g.open_in_insert_mode=0
    vim.g.preserve_alternate_buffer=1
end

return {
    init=init
}
