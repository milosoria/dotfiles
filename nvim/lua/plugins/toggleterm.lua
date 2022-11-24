local function init()
    vim.api.nvim_set_keymap("n", "<Leader>tt", ":ToggleTerminal<CR>", { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>t\\", ":vsplit | :ToggleTerminal<CR>", { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>t-", ":split<CR>|:resize -10<CR>|:ToggleTerminal<CR>", { noremap = true })
    vim.g.open_in_insert_mode = 1
    vim.g.preserve_alternate_buffer = 1
end

return {
    init = init,
}
