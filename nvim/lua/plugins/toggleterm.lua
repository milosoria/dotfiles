local function init()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
    vim.g.auto_start_insert =0
    vim.g.preserve_alternate_buffer=0	--Preserve the alternate_buffer of the current window when opening and closing the terminal	1
    vim.g.auto_start_insert=0	--enter insert mode automatically when given focus. Uses BufEnter event	0
    vim.g.open_in_insert_mod=0
end

return {
    init=init
}
