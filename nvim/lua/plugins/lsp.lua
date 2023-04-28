local function on_attach(client, bufnr)
    -- Mappings
    local opts = { noremap = true, silent = true }
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    if not string.match(vim.api.nvim_buf_get_name(bufnr), "NvimTree_1") then
        if client.server_capabilities.documentFormattingProvider then
            -- format
            -- vim.api.nvim_command [[augroup Format]]
            -- vim.api.nvim_command [[autocmd! * <buffer>]]
            -- vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async=true})]]
            -- vim.api.nvim_command [[augroup END]]
            vim.api.nvim_buf_set_keymap(
                bufnr,
                "n",
                "<Leader>n",
                "<cmd>lua vim.lsp.buf.format({async=true})<CR>",
                { noremap = true }
            )
        end
    end

    -- diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        signs = true,
        update_in_insert = true,
    })

    -- goto decl/def
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- references to quickfix list
    buf_set_keymap("n", "<leader>vrr", " <Cmd>lua vim.lsp.buf.references()<CR>", opts)

    -- Show signature help on insert mode
    buf_set_keymap("i", "<C-K>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

-- config that activates keymaps and enables snippet support
local function make_config()
    -- Setup lspconfig.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not ok then
        print("Failed to load cmp_nvim_lsp")
        return
    end
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    return {
        -- enable snippet support
        capabilities = capabilities,
        -- map buffer local keybindings when the language server attaches on_attach = on_attach
        on_attach = on_attach,
    }
end

local function init()
    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).

    local ok1, mason_lspconfig = pcall(require, "mason-lspconfig")
    local ok2, mason = pcall(require, "mason")
    local ok3, lspconfig = pcall(require, "lspconfig")
    local ok4, mason_null_ls = pcall(require, "mason-null-ls")
    if not ok1 or not ok2 or not ok3 or not ok4 then
        print("Failed to load mason-lspconfig, mason, lspconfig, or mason-null-ls")
        return
    end

    mason.setup({})
    mason_lspconfig.setup({
        automatic_installation = true,
    })
    mason_null_ls.setup({
        automatic_installation = true,
        ensure_installed = {
            "prettier",
            "stylua",
            "eslint_d",
        },
    })

    local config = make_config()
    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        lspconfig[server].setup(config)
    end
end

return {
    init = init,
}
