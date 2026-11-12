-- colorscheme follows ~/.config/theme/current (managed by the `theme` command)
-- the file holds "<theme> <variant>", e.g. "gruvbox-material light"
local theme = "tokyonight-night"
local f = io.open(vim.fn.expand("~/.config/theme/current"), "r")
if f then
  local line = f:read("*l") or ""
  f:close()
  local light = line:find("light") ~= nil
  vim.o.background = light and "light" or "dark"
  if line:find("gruvbox") then
    theme = "gruvbox-material"
  elseif light then
    theme = "tokyonight-day"
  end
end

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      -- day: gruvbox light neutrals (cream bg, fg, grays) so both light themes share bg/fg,
      -- only the tokyo accents change. Matches kitty/tmux/claude tokyonight-day files.
      on_colors = function(c)
        if vim.o.background ~= "light" then
          return
        end
        require("tokyonight.util").bg = "#f2e5bc" -- blends (diff, visual) are computed against it
        c.bg = "#f2e5bc"
        c.bg_dark, c.bg_dark1, c.bg_highlight = "#ebdbb2", "#e5d4a8", "#ebdbb2"
        c.bg_popup, c.bg_statusline, c.bg_sidebar, c.bg_float = c.bg_dark, c.bg_dark, c.bg, c.bg
        c.bg_visual, c.bg_search = "#d5c4a1", "#d5c4a1"
        c.fg, c.fg_dark, c.fg_float, c.fg_sidebar = "#3c3836", "#504945", "#3c3836", "#504945"
        c.fg_gutter, c.comment = "#bdae93", "#7c6f64"
        c.dark3, c.dark5, c.terminal_black = "#928374", "#7c6f64", "#665c54"
        -- tokyo day accents darkened to >= 4.5:1 on the cream bg (same values as kitty/claude)
        local accents = {
          blue = "#1561ca", blue1 = "#156f7e", blue2 = "#066e80", cyan = "#006d92",
          magenta = "#812eee", magenta2 = "#c80060", purple = "#7847bd", orange = "#9d5100",
          yellow = "#7c6037", green = "#526c35", green1 = "#376e66", green2 = "#2a6d77",
          teal = "#0e715d", red = "#c90941", red1 = "#b63737",
        }
        for k, v in pairs(accents) do
          c[k] = v
        end
        c.error, c.warning, c.info, c.hint, c.todo = c.red1, c.yellow, c.blue2, c.teal, c.blue
      end,
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_better_performance = 1
      -- dark: darker editor bg to match kitty's background
      -- light: "original" foreground, the "material" one is too washed out on a light bg
      vim.api.nvim_create_autocmd("ColorSchemePre", {
        pattern = "gruvbox-material",
        callback = function()
          local dark = vim.o.background == "dark"
          vim.g.gruvbox_material_foreground = dark and "material" or "original"
          -- light: "soft" bg0 (#f2e5bc) = kitty/tmux cream background
          vim.g.gruvbox_material_background = dark and "hard" or "soft"
          vim.g.gruvbox_material_colors_override = dark and { bg0 = { "#141617", "233" } } or vim.empty_dict()
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme,
    },
  },
}
