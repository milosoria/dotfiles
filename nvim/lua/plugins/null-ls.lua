local function init()
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
        print("Failed to load null_ls")
        return
    end
    local formatting = null_ls.builtins.formatting
    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
        sources = {
            formatting.stylua,
            formatting.prettier,
            formatting.eslint_d,
            code_actions.eslint_d,
            diagnostics.eslint_d,
            formatting.rustfmt,
            formatting.ruff,
        },
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePost", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            filter = function()
                                return client.name == "null-ls"
                            end,
                            async = true,
                        })
                    end,
                })
            end
        end,
    })
end

return {
    init = init,
}
