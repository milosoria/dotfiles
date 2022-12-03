local function init()
    local ok, lspsaga = pcall(require, "lspsaga")
    if not ok then
        print("Failed to load lspsaga")
        return
    end
    lspsaga.init_lsp_saga({
        border_style = "rounded",
    })

    -- References and definitions finder
    vim.keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
    -- Code actions
    vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
    -- Function info
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
    -- Rename
    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
    -- Preview Definition
    vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
    -- show errors and warnings in float
    vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
end

return {
    init = init,
}
