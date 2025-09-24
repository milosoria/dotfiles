return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
  },
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- change a keymap
    keys[#keys + 1] = {
      "<C-y>",
      false,
    }
    keys[#keys + 1] = {
      "gr",
      false,
    }
  end,
  setup = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("mason").setup()
    require("mason-lspconfig").setup()
    -- Setup Mason LSP handlers with blink.cmp capabilities
    require("mason-lspconfig").setup_handlers({
      -- The default handler will be called for each installed server
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
    })
  end,
}
