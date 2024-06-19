local function init()
    local ok, gitblame = pcall(require, "gitblame")

    if not ok then
        print("Failed to load gitblame")
        return
    end

    local settings = {
        noremap = true,
    }

    gitblame.setup({
        enabled = false,
    })
    vim.api.nvim_set_keymap("n", "<leader>gb", ":GitBlameToggle<CR>", settings)
end

return {
    init = init,
}
