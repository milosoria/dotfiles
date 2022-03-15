local function init()

    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').setup{
        defaults = {
            file_ignore_patterns = {".git","node_modules", "./yarn.*", "yarn.*"},
            selection_caret = "> ",
            prompt_prefix = "🔍 ",
            initial_mode = "insert",
            layout_strategy = "horizontal",
            layout_config = {
                width = 0.80,
                preview_cutoff = 1,
                horizontal = {
                    mirror = false,
                },
                vertical = {
                    mirror = false,
                },
            },
            pickers = {
                file_browser={
                    theme="dropdown"
                },
                current_buffer_fuzzy_find ={
                    theme="dropdown",
                    previewer=false
                }
            },
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    }


    -- grep string in the current directory
    vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope current_buffer_fuzzy_find theme=dropdown previewer=false <CR>', { noremap = true})
    -- list code actions
    vim.api.nvim_set_keymap('n', '<Leader>vca', ':Telescope lsp_code_actions theme=dropdown <CR>', { noremap = true})
    -- find_files in the current directory
    vim.api.nvim_set_keymap('n', '<Leader>p', ':Telescope find_files <CR>', { noremap = true})
    -- neovim config directory
    vim.api.nvim_set_keymap('n', '<Leader>vim', ':Telescope find_files cwd=~/.config/nvim<CR>', { noremap = true})
    -- zsh config directory
    vim.api.nvim_set_keymap('n', '<Leader>zsh', ':Telescope find_files cwd=~/.config/zsh<CR>', { noremap = true})
    -- buffers
    vim.api.nvim_set_keymap('n', '<Leader>b', ':Telescope buffers<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>c', ':Telescope command_history<CR>', { noremap = true})

    -- this needs to be called after the setup call
    require('telescope').load_extension('fzf')
end

return {
    init=init
}
