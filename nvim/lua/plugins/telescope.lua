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
    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                ".git",
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
            },
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case" or "smart_case"
            },
        },
    })

    -- grep string in the current directory
    vim.api.nvim_set_keymap("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true })
    vim.api.nvim_set_keymap(
        "n",
        "<Leader>fb",
        ":Telescope current_buffer_fuzzy_find theme=dropdown previewer=false <CR>",
        { noremap = true }
    )
    -- list code actions
    vim.api.nvim_set_keymap("n", "<Leader>vca", ":Telescope lsp_code_actions theme=dropdown <CR>", { noremap = true })
    -- find_files in the current directory
    vim.api.nvim_set_keymap("n", "<Leader>p", ":Telescope find_files  <CR>", { noremap = true })
    -- neovim config directory
    vim.api.nvim_set_keymap("n", "<Leader>vim", ":Telescope find_files cwd=~/.config/nvim<CR>", { noremap = true })
    -- zsh config directory
    vim.api.nvim_set_keymap("n", "<Leader>zsh", ":Telescope find_files cwd=~/.config/zsh<CR>", { noremap = true })
    -- this needs to be called after the setup call
    telescope.load_extension("fzf")
end

return {
    init = init,
}
