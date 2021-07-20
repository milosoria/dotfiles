local function init()
    require('telescope').load_extension('media_files')
    require('telescope').load_extension('fzy_native')
    require('telescope').setup{
        defaults = {
            file_ignore_patterns = {"./node_modules/*", "node_modules", "^node_modules/*", "node_modules/*", "./yarn.*", "yarn.*"},
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
            file_sorter =  require'telescope.sorters'.get_fzy_sorter,
            color_devicons = true,
            winblend = 0,
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
        }
    }
end

return {
    init=init
}
