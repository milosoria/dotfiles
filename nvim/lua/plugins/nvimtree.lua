local function open_nvim_tree()
    -- open the tree always
    require("nvim-tree.api").tree.open()
end

local function init()
    local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        print("Failed to load nvim-web-devicons")
        return
    end
    -- Open nvim tree on vim enter
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    nvim_web_devicons.setup({
        default = true,
    })

    vim.api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeToggle<CR>:NvimTreeRefresh<CR>", { noremap = true })

    local ok, nvimtree = pcall(require, "nvim-tree")
    if not ok then
        print("Failed to load nvimtree")
        return
    end

    nvimtree.setup({
        disable_netrw = true,
        hijack_netrw = true,
        ignore_buffer_on_setup = false,
        auto_reload_on_write = true,
        open_on_tab = false,
        update_cwd = false,
        hijack_unnamed_buffer_when_opening = true,
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        update_focused_file = {
            enable = true,
            update_cwd = false,
            ignore_list = {},
        },
        system_open = {
            cmd = nil,
            args = {},
        },
        filters = {
            dotfiles = false,
            custom = {},
        },
        git = {
            enable = true,
            ignore = false,
            timeout = 500,
        },
        view = {
            width = 30,
            hide_root_folder = false,
            side = "left",
            preserve_window_proportions = false,
            mappings = {
                custom_only = false,
                list = {},
            },
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        trash = {
            cmd = "trash",
            require_confirm = true,
        },
        actions = {
            change_dir = {
                enable = true,
                global = false,
            },
            open_file = {
                quit_on_open = true,
                resize_window = false,
                window_picker = {
                    enable = true,
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
        },
        log = {
            enable = false,
            types = {
                all = false,
                config = false,
                git = false,
            },
        },
        renderer = {
            icons = {
                glyphs = {
                    default = "",
                    symlink = "",
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                    },
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                },
            },
        },
    })
end

return {
    init = init,
}
