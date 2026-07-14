-- colorscheme follows ~/.config/theme/current (managed by the `theme` command)
local theme = "tokyonight"
local f = io.open(vim.fn.expand("~/.config/theme/current"), "r")
if f then
  local line = f:read("*l")
  f:close()
  if line and line:find("gruvbox") then
    theme = "gruvbox-material"
  end
end

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
      -- darker editor bg to match kitty's gruvbox background
      vim.g.gruvbox_material_colors_override = { bg0 = { "#141617", "233" } }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme,
    },
  },
}
