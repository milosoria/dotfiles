local function init()
    require'nvim-web-devicons'.setup {
        default = true;
    }

    vim.g.nvim_tree_quit_on_open = 1 --0 by default, closes the tree when you open a file
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

    vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true})

    require'nvim-tree'.setup {
        disable_netrw       = true,
        hijack_netrw        = true,
        open_on_setup       = false,
        ignore_ft_on_setup  = {},
        auto_close          = false,
        open_on_tab         = false,
        hijack_cursor       = true,
        update_cwd          = false,
        update_to_buf_dir   = {
            enable = true,
            auto_open = true,
        },
        diagnostics = {
            enable = false,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            }
        },
        update_focused_file = {
            enable      = false,
            update_cwd  = false,
            ignore_list = {}
        },
        system_open = {
            cmd  = nil,
            args = {}
        },
        filters = {
            dotfiles = false,
            custom = {}
        },
        git = {
            enable = true,
            ignore = false,
            timeout = 500,
        },
        view = {
            width = 30,
            height = 30,
            hide_root_folder = false,
            side = 'left',
            auto_resize = false,
            mappings = {
                custom_only = false,
                list = {}
            },
            number = false,
            relativenumber = false
        },
        trash = {
            cmd = "trash",
            require_confirm = true
        }
    }

end

return {
    init=init
}
