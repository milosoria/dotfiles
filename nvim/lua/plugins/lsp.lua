local function on_attach(client, bufnr)

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    -- diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable underline, it's very annoying
            underline = false,
            signs = true,
            update_in_insert = false
        })

    -- Mappings
    local opts = { noremap = true, silent = true }
    -- goto decl/def
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

    -- show code actions available
    buf_set_keymap('n','<leader>vca',' <Cmd>lua vim.lsp.buf.code_action()<CR>',opts)
    -- show errors and warnings in float
    buf_set_keymap('n','<leader>vsd',' <Cmd>lua vim.diagnostic.open_float()<CR>',opts)

    -- show help
    buf_set_keymap('n','<leader>vsh',' <Cmd>lua vim.lsp.buf.signature_help()<CR>',opts)

    -- references to quickfix list
    buf_set_keymap('n','<leader>vrr',' <Cmd>lua vim.lsp.buf.references()<CR>',opts)

    -- function info
    buf_set_keymap('n','K','<Cmd>lua vim.lsp.buf.hover()<CR>',opts)

    -- navigate quickly through diagnostics
    buf_set_keymap('n','<leader>vn',':lua vim.lsp.diagnostic.goto_next()<CR>',opts)
    buf_set_keymap('n','<leader>vp',':lua vim.lsp.diagnostic.goto_prev()<CR>',opts)


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
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    return {
        -- enable snippet support
        capabilities = capabilities,
        -- map buffer local keybindings when the language server attaches on_attach = on_attach
        on_attach= on_attach
    }
end

local function init()

    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).

    local lspinstaller = require'nvim-lsp-installer'
    local lspconfig = require'lspconfig'

    lspinstaller.setup{}
    local config = make_config()
    for _, server in ipairs(lspinstaller.get_installed_servers()) do
        lspconfig[server.name].setup(config)
    end
end

return {
    init=init
}
