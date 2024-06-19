local function init()
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    local ok, telescope = pcall(require, "telescope")
    if not ok then
        print("Failed to load telescope")
        return
    end
    local previewers = require("telescope.previewers")
    local sorters = require("telescope.sorters")
    local opts = { noremap = true }
    local additional_rg_args = { "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" }
    local map = vim.api.nvim_set_keymap
    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                "%.git",
                ".git/",
                "node_modules",
                "__pycache__",
                "%.png",
                "%.jpeg",
                "%.jpg",
                "%.lock",
                "%.mp3",
                "%.mp4",
            },
            file_sorter = sorters.get_fzy_sorter,
            color_devicons = true,
            file_previewer = previewers.vim_buffer_cat.new,
            grep_previewer = previewers.vim_buffer_vimgrep.new,
            qflist_previewer = previewers.vim_buffer_qflist.new,
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
                file_browser = {
                    theme = "dropdown",
                },
                current_buffer_fuzzy_find = {
                    theme = "dropdown",
                    previewer = false,
                },
                live_grep = {
                    theme = "dropdown",
                    additional_args = additional_rg_args,
                },
            },
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case",
            },
        },
    })
    --
    -- grep string in the current directory
    map("n", "<leader>fg", ':Telescope live_grep theme=dropdown <CR>', opts)
    -- map("n", "<Leader>fg", builtin.live_grep(), opts)
    map("n", "<Leader>fb", ":Telescope current_buffer_fuzzy_find theme=dropdown previewer=false <CR>", opts)
    -- list code actions
    map("n", "<Leader>vca", ":Telescope lsp_code_actions theme=dropdown <CR>", opts)
    -- find_files in the current directory
    map(
        "n",
        "<Leader>p",
        ":lua require('telescope.builtin').find_files({no_ignore = false, hidden = true, previewer = true, layout_strategy = 'vertical', layout_config = { width = 0.5, height = 0.8, preview_height = 0.20 }, theme = 'dropdown'}) <CR>",
        opts
    )
    -- neovim config directory
    map("n", "<Leader>vim", ":Telescope find_files cwd=~/.config/nvim<CR>", opts)
    -- zsh config directory
    map("n", "<Leader>zsh", ":Telescope find_files cwd=~/.config/zsh<CR>", opts)
    -- this needs to be called after the setup call
    telescope.load_extension("fzf")
end

return {
    init = init,
}
