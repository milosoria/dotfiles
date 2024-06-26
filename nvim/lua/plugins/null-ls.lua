local function init()
    local ok, null_ls = pcall(require, "null-ls")
    local ok2, lsp_format = pcall(require, "lsp-format")
    if not ok or not ok2 then
        print("Failed to load null_ls or/and lsp-format")
        return
    end
    local formatting = null_ls.builtins.formatting
    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    lsp_format.setup({})

    null_ls.setup({
        sources = {
            formatting.ruff,
            formatting.black,
            -- formatting.pyflyby,
            formatting.stylua,
            formatting.prettier,
            formatting.eslint_d,
            formatting.rustfmt,
            diagnostics.eslint_d,
            -- diagnostics.pylint,
        },
        on_attach = function(client, bufnr)
            if client.name == "null-ls" then
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "<Leader>n",
                    "<cmd>lua vim.lsp.buf.format({async=true})<CR>",
                    { noremap = true }
                )

                -- lsp_format.on_attach(client)
            end
        end,
        diagnostics_format = "[#{s}] #{m}",
    })
end

return {
    init = init,
}
