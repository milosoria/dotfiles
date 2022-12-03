local function init()
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
        print("Failed to load null_ls")
        return
    end
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
        sources = {
            formatting.stylua,
            formatting.prettier,
            diagnostics.eslint_d,
        },
        on_attach = function(current_client, bufnr)
            if current_client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            filter = function(client)
                                return client.name == "null-ls"
                            end,
                            bufnr = bufnr,
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
