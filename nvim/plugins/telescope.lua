require('telescope').load_extension('media_files')
require('telescope').load_extension('fzy_native')
require('telescope').setup{
defaults = {
    vimgrep_arguments = {
        'rg',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
        },
    file_ignore_patterns = {"./node_modules/*", "node_modules", "^node_modules/*", "node_modules/*", "./yarn.*", "yarn.*"},
    prompt_position = "bottom",
    selection_caret = "> ",
    prompt_prefix = "🔍 ",
entry_prefix = "  ",
initial_mode = "insert",
selection_strategy = "reset",
sorting_strategy = "descending",
layout_strategy = "horizontal",
layout_defaults = {
    horizontal = {
        mirror = false,
        },
    vertical = {
        mirror = false,
        },
    },
file_sorter =  require'telescope.sorters'.get_fzy_sorter,
color_devicons = true,
shorten_path = true,
winblend = 0,
width = 0.75,
results_height = 1,
preview_cutoff = 1,
results_width = 0.8,
border = {},
borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
use_less = true,
file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
extensions ={
fzy_native = {
    override_generic_sorter = false,
    override_file_sorter =true,
    }
},
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}
