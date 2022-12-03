local function init()
    local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
    if not ok then
        print("Failed to load treesitter")
        return
    end

    require("nvim-treesitter.configs").setup({
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            "lua",
            "go",
            "ruby",
            "json",
            "rust",
            "bash",
            "python",
            "javascript",
            -- "c",
        },

        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,

        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            --
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = false,
            disable = {},
        },
        autotag = {
            enable = true,
        },
    })
end

return {
    init = init,
}
