local function init()
    vim.cmd [[
        imap <silent><script><expr> <C-J> copilot#Accept('\<CR>')
        let g:copilot_no_tab_map = v:true
    ]]
    vim.api.nvim_set_keymap('n', '<leader>co', ':Copilot panel<CR>', { noremap = true, silent = true })
end

return {
    init = init
}
