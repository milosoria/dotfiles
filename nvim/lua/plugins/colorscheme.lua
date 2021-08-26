-- "Colorscheme configs
local function init()

    -- Load colorscheme

    -- Theme settings
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_terminal_colors=true
    vim.g.tokyonight_transparent = true
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal"}
    vim.g.tokyonight_dark_sidebar=false

    vim.cmd('colorscheme tokyonight')
end

return {
    init = init
}
