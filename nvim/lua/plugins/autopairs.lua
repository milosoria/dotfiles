local function init()
    require('nvim-autopairs').setup(
        {
            disable_filetype = { 'TelescopePrompt', 'vim' }
        }
    )
end

return {
    init = init
}
