local function init()
    ---tresitter for highlighting
    require'nvim-treesitter.configs'.setup { highlight = { enable = true }, ensure_installed = "maintained"}
end

return {
    init=init
}
