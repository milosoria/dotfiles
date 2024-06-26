-- Colorscheme configs
local function init()
    local ok, colorscheme = pcall(require, "tokyonight")
    if not ok then
        print("Failed to load gruvbox")
        return
    end
    vim.o.background = "dark" -- or "light" for light mode
    colorscheme.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
    })
    -- setup must be called before loading
    -- colorscheme.setup({
    --     terminal_colors = true, -- add neovim terminal colors
    --     undercurl = true,
    --     underline = true,
    --     bold = false,
    --     italic = {
    --         strings = true,
    --         emphasis = true,
    --         comments = true,
    --         operators = false,
    --         folds = true,
    --     },
    --     strikethrough = true,
    --     invert_selection = false,
    --     invert_signs = false,
    --     invert_tabline = false,
    --     invert_intend_guides = false,
    --     inverse = true, -- invert background for search, diffs, statuslines and errors
    --     contrast = "hard", -- can be "hard", "soft" or empty string
    --     palette_overrides = {},
    --     overrides = {},
    --     dim_inactive = false,
    --     transparent_mode = true,
    -- })
    vim.cmd("colorscheme tokyonight")
    vim.cmd("highlight clear SignColumn")
    -- vim.cmd("highlight BufferTabpageFill guibg=#262626")

    -- vim.cmd("colorscheme gruvbox")
    -- colorscheme.setup({
    --     -- your configuration comes here
    --     -- or leave it empty to use the default settings
    --     style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    --     transparent = true, -- Enable this to disable setting the background color
    --     terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    --     styles = {
    --         -- Style to be applied to different syntax groups
    --         -- Value is any valid attr-list value `:help attr-list`
    --         comments = "italic",
    --         keywords = "italic",
    --         functions = "NONE",
    --         variables = "NONE",
    --         -- Background styles. Can be "dark", "transparent" or "normal"
    --         sidebars = "transparent", -- style for sidebars, see below
    --         floats = "transparent", -- style for floating windows
    --     },
    --     day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    --     hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    --     dim_inactive = false, -- dims inactive windows
    --     lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
    -- })
    -- vim.cmd("colorscheme tokyonight")

    -- bg to none so winseparator shows only a thin line
    -- fg to none so winseparator shows only a thin line
    vim.cmd([[
        highlight WinSeparator guifg=#5f66b3
        highlight WinSeparator guibg=None
        highlight DiagnosticVirtualTextError guifg=#db4b4b guibg=None
        highlight DiagnosticVirtualTextWarn guifg=#e0af68  guibg=None
        highlight DiagnosticVirtualTextInfo guifg=#0db9d7  guibg=None 
        highlight DiagnosticVirtualTextHint guifg=#1abc9c  guibg=None
    ]])
end

return {
    init = init,
}
