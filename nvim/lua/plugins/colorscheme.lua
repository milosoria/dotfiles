-- Colorscheme configs
local function init()
    local ok, tokyonight = pcall(require, "tokyonight")
    if not ok then
        print("Failed to load tokyonight")
        return
    end
    tokyonight.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night",        -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value `:help attr-list`
            comments = "italic",
            keywords = "italic",
            functions = "NONE",
            variables = "NONE",
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "transparent",     -- style for sidebars, see below
            floats = "transparent",       -- style for floating windows
        },
        day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false,             -- dims inactive windows
        lualine_bold = true,              -- When `true`, section headers in the lualine theme will be bold
    })
    vim.cmd("colorscheme tokyonight")

    -- bg to none so winseparator shows only a thin line
    -- fg to none so winseparator shows only a thin line
    --
    vim.cmd([[
        highlight WinSeparator guifg=#BEBEBE
        highlight WinSeparator guibg=None
    ]])
end

return {
    init = init,
}
