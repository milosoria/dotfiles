local function init()
    local ok, lualine = pcall(require, "lualine")
    if not ok then
        print("Failed to load lualine")
        return
    end
    lualine.setup({
        options = {
            theme = "tokyonight",
            component_separators = { "", "" },
            section_separators = { "", "" },
        },
        section_b = {
            "branch",
            "diff",
            "diagnostics",
            sources = { "nvim_lsp" },
        },
    })
end

return {
    init = init,
}
