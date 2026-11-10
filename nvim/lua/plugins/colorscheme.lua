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
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      -- dark: darker editor bg to match kitty's background
      -- light: "original" foreground, the "material" one is too washed out on a light bg
      vim.api.nvim_create_autocmd("ColorSchemePre", {
        pattern = "gruvbox-material",
        callback = function()
          local dark = vim.o.background == "dark"
          vim.g.gruvbox_material_foreground = dark and "material" or "original"
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
