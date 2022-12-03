local function init()
    local ok, autopairs = pcall(require, "nvim-autopairs")
    if not ok then
        print("Failed to load nvim-autopairs")
        return
    end
    autopairs.setup({
        disable_filetype = { "TelescopePrompt", "vim" },
    })
end

return {
    init = init,
}
