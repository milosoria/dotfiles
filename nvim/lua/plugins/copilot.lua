local function init()
    vim.cmd([[
        imap <silent><script><expr> <C-Y> copilot#Accept('\<CR>')
        let g:copilot_no_tab_map = v:true
        let g:copilot_filetypes = {
        \   'yaml': v:true,
        \}
    ]])
    vim.api.nvim_set_keymap("n", "<leader>co", ":Copilot panel<CR>", { noremap = true, silent = true })
end

return {
    init = init,
}
