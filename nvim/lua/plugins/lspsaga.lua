return {
  "glepnir/lspsaga.nvim",
  keys = {
    { "gr", "<cmd>Lspsaga finder<CR>", desc = "LSP Finder", silent = true },
    { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action", silent = true },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation", silent = true },
    { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Diagnostics", silent = true },
  },
}
