local function init()
    require'lspinstall'.setup() -- important
    local servers = require'lspinstall'.installed_servers()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    for _, server in pairs(servers) do
        if server == 'cpp' then
            require'lspconfig'[server].setup{capabilities=capabilities, on_attach=require'completion'.on_attach,default_config= { filetypes={'c', 'objc'}}}
        else
            require'lspconfig'[server].setup{capabilities=capabilities,on_attach=require'completion'.on_attach}
        end
    end
    require'lspinstall'.post_install_hook = function ()
        setup_servers() -- reload installed servers
        vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
    end
end

return {
    init=init
}
