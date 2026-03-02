return {
  {
    "caenrique/nvim-toggle-terminal",
    keys = {
      { "<Leader>tt", ":ToggleTerminal<CR>", desc = "Toggle terminal" },
      { "<Leader>t\\", ":vsplit | :ToggleTerminal<CR>", desc = "Toggle terminal (vertical split)" },
      { "<Leader>t-", ":split<CR>|:resize -10<CR>|:ToggleTerminal<CR>", desc = "Toggle terminal (horizontal split)" },
    },
  },
}
