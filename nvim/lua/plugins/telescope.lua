local function init()
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
                width = 0.75,
                prompt_position = "bottom",
                preview_cutoff = 1,
                horizontal = {
                    mirror = false,
                },
                vertical = {
                    mirror = false,
                },
            },
            file_sorter =  require'telescope.sorters'.get_fuzzy_file,
            generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
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
            extensions ={
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter =true,
                }
            },
        }
    }
    require('telescope').load_extension('media_files')
    require('telescope').load_extension('fzy_native')
    vim.api.nvim_set_keymap('n', '<Leader>f', ':Telescope live_grep<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>b', ':Telescope buffers<CR>', { noremap = true})
    vim.api.nvim_set_keymap('n', '<Leader>p', ':Telescope find_files hidden=true<CR>', { noremap = true})
end

return {
    init=init
}
