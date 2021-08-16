local function init()
    require'nvim-web-devicons'.setup {
        default = true;
    }
    vim.g.nvim_tree_auto_open=1
    vim.g.nvim_tree_auto_close=0
    vim.g.nvim_tree_quit_on_open=1
    vim.g.nvim_tree_follow=1
    vim.g.nvim_tree_indent_markers=1
    vim.g.nvim_tree_git_hl=1
    vim.g.nvim_tree_highlight_opened_files=1
    vim.g.nvim_tree_root_folder_modifier=':~'
    vim.g.nvim_tree_highlight_opened_files = 1
    vim.g.nvim_tree_lsp_diagnostics=1
    vim.g.nvim_tree_disable_window_picker = 1
    vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>r', ':NvimTreeRefresh<CR>', { noremap = true})
end

return {
    init=init
}
