-- "Colorscheme configs
local function init()

    -- Gruvbox option
    -- Theme settings
    vim.g.gruvbox_contrast_dark = "hard"
    -- Load
    vim.cmd('colorscheme gruvbox')

    -- Tokyonight option
    -- Theme settings
    -- vim.g.tokyonight_style='storm'
    -- This makes tokyonight respect terminal background color
    -- vim.g.tokyonight_transparent=true
    -- vim.g.tokyonight_dark_sidebar=false
    -- vim.g.tokyonight_transparent_sidebar=true
    -- vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal"}
    -- vim.g.tokyonight_lualine_bold=true
    -- vim.g.colors_name='tokyonight'
    -- vim.g.tokyonight_italic_functions = true
    -- vim.g.tokyonight_terminal_colors=true
    -- vim.g.tokyonight_transparent = true
    -- vim.g.tokyonight_dark_sidebar=false
    -- Load
    -- vim.cmd('colorscheme tokyonight')
end

return {
    init = init
}
