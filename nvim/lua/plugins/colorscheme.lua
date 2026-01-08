return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   config = function()
  --     require("kanagawa").setup({
  --       compile = false, -- enable compiling the colorscheme
  --       undercurl = true, -- enable undercurls
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false, -- do not set background color
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       colors = { -- add/modify theme and palette colors palette = {},
  --         theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  --       },
  --       overrides = function(colors) -- add/modify highlights
  --         return {}
  --       end,
  --       theme = "lotus", -- Load "wave" theme when 'background' option is not set
  --     })
  --   end,
  -- },
  "ellisonleao/gruvbox.nvim",
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.cmd([[set termguicolors]])
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
