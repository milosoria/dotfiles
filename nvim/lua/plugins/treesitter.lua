local function init()
    ---tresitter for highlighting
    require'nvim-treesitter.configs'.setup{
        ensure_installed ='maintained',
        highlight = {
            enable = true
        },
        -- indent = {
        --     enable = true
        -- }
    }
end

return {
    init=init
}
