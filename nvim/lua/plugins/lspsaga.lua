return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lspsaga").setup({})
  end,
  keys = {
    { "gr", "<cmd>Lspsaga finder<CR>", desc = "LSP Finder", silent = true },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation", silent = true },
  },
}
