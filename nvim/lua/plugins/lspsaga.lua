return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({})
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  keys = {
    { "gr", "<cmd>Lspsaga finder<CR>", desc = "LSP Finder", silent = true },
    { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action", silent = true },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation", silent = true },
    { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Diagnostics", silent = true },
  },
}
