local function init()
    require'nvim-web-devicons'.setup {
        default = true;
    }

    vim.g.nvim_tree_icons = {
           default=        '',
           symlink=        '',
           git= {
             unstaged=     "✗",
             staged=       "✓",
             unmerged=     "",
             renamed=      "➜",
             untracked=    "★",
             deleted=      "",
            },
           folder= {
             arrow_open=   "",
             arrow_closed= "",
             default=      "",
             open=         "",
             empty=        "",
             empty_open=   "",
             symlink=      "",
             symlink_open= "",
            },
            lsp= {
              hint= "",
              info= "",
              warning= "",
              error= "",
            }
           }

    vim.g.nvim_tree_auto_open=0
    -- Can be `0` or `1`. When `1`, will open the tree when the package is loaded.
    -- It's not relying on VimEnter anymore.
    -- Default is 0

    vim.g.nvim_tree_auto_close=0
    -- Can be `0` or `1`. When `1`, will bind |BufEnter| to automatically
    -- close the tree if it's the last window.
    -- Default is 0

    vim.g.nvim_tree_quit_on_open=1
    -- Can be `0` or `1`. When `1`, will close the tree when a file is opened.
    -- Applies to: `edit`, `vsplit`, `split`, `tabnew`.
    -- Default is 0

    vim.g.nvim_tree_add_trailing=1
    vim.g.nvim_tree_indent_markers=1
    vim.g.nvim_tree_follow=1
    vim.g.nvim_tree_indent_markers=1
    vim.g.nvim_tree_git_hl=1
    vim.g.nvim_tree_update_cwd = 0 -- will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
    vim.g.nvim_tree_respect_buf_cwd = 1 -- will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
    vim.g.nvim_tree_root_folder_modifier=':~'
    vim.g.nvim_tree_highlight_opened_files=3
    vim.g.nvim_tree_lsp_diagnostics=1
    vim.g.nvim_tree_disable_window_picker = 1

    vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>r', ':NvimTreeRefresh<CR>', { noremap = true})
end

return {
    init=init
}
