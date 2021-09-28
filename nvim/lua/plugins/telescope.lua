local function init()

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
    require('telescope').setup{
        defaults = {
            file_ignore_patterns = {".git/","./node_modules/*", "node_modules", "^node_modules/*", "node_modules/*", "./yarn.*", "yarn.*"},
            selection_caret = "> ",
            prompt_prefix = "🔍 ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_config = {
                width = 0.80,
                prompt_position = "bottom",
                preview_cutoff = 1,
                horizontal = {
                    mirror = false,
                },
                vertical = {
                    mirror = false,
                },
            },
            color_devicons = true,
            winblend = 0,
            border = {},
            borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            use_less = true,
            --this is new (default nil)
            set_env = { ['COLORTERM'] = 'truecolor' },
            file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode="smart_case"
                }
            }
        }
    }

    require('telescope').load_extension('fzf')

    -- grep string in the current directory
    vim.api.nvim_set_keymap('n', '<Leader>f', ':Telescope live_grep()<CR>', { noremap = true})
    -- find_files in the current directory
    vim.api.nvim_set_keymap('n', '<Leader>p', ':Telescope find_files<CR>', { noremap = true})
    -- neovim config directory
    vim.api.nvim_set_keymap('n', '<Leader>v', ':Telescope find_files cwd=~/.config/nvim<CR>', { noremap = true})
    -- global
    vim.api.nvim_set_keymap('n', '<Leader>g', ':Telescope find_files theme=ivy cwd=~ <CR>', { noremap = true})
    -- buffers
    vim.api.nvim_set_keymap('n', '<Leader>b', ':Telescope buffers<CR>', { noremap = true})
end

return {
    init=init
}
