local function init()
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
            },
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
            shorten_path = true,
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
            -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
        }
    }
end

return {
    init=init
}
