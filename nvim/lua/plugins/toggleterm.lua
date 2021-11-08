local function init()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':ToggleTerminal<CR>', { noremap = true})
    vim.g.preserve_alternate_buffer=1	--Preserve the alternate_buffer of the current window when opening and closing the terminal	1
    vim.g.open_in_insert_mod=0
end

return {
    init=init
}
