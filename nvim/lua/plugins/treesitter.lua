local function init()
    ---tresitter for highlighting
    require'nvim-treesitter.configs'.setup{
        ensure_installed ='maintained',
         highlight = {
            enable = true,
            additional_vim_regex_highlighting = true
        },
        indent = {
            enable = true
        }
    }
end

return {
    init=init
}
