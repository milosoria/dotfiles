-- "Colorscheme configs
local function init()

    -- Gruvbox option:
    -- Theme settings
    -- vim.g.gruvbox_contrast_dark = "hard"
    -- Load
    -- vim.cmd('colorscheme gruvbox')

    -- Tokyonight option:
    -- Theme settings:
    vim.g.tokyonight_style='night'
    -- This makes tokyonight respect terminal background color:
    -- vim.g.tokyonight_transparent=true
    vim.g.tokyonight_terminal_colors=true
    vim.g.tokyonight_lualine_bold=true
    vim.g.colors_name='tokyonight'
    vim.g.tokyonight_transparent_sidebar=true
    vim.g.tokyonight_dark_sidebar=true
    vim.g.tokyonight_dark_float=true
    -- Load
    vim.cmd('colorscheme tokyonight')
end

return {
    init = init
}
