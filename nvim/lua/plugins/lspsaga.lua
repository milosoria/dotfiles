local function init()
    local ok, lspsaga = pcall(require, "lspsaga")
    if not ok then
        print("Failed to load lspsaga")
        return
    end
    lspsaga.setup({
        ui = {
            border = "double",
            colors = {
                --float window normal background color
                normal_bg = "#1F1F26",
                --title background color
                title_bg = "#afd700",
                red = "#e95678",
                magenta = "#b33076",
                orange = "#FF8700",
                yellow = "#f7bb3b",
                green = "#afd700",
                cyan = "#36d0e0",
                blue = "#61afef",
                purple = "#CBA6F7",
                white = "#d1d4cf",
                black = "#1c1c19",
            },
        },
    })
    local keymap = vim.keymap.set
    -- References and definitions finder
    keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
    -- Code actions
    keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
    -- Function info
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
    -- Rename
    keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
    -- Preview Definition
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
    -- show errors and warnings in float
    keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
    -- Diagnostic jump can use `<c-o>` to jump back
    keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
end

return {
    init = init,
}
