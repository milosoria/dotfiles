return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "mason-org/mason.nvim",
  },
  opts = function(_, opts)
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

    -- TypeScript with Vue plugin
    opts.servers = opts.servers or {}
    opts.servers.ts_ls = {
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            languages = { "vue" },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }

    -- Vue Language Server
    opts.servers.vue_ls = {}
  end,
}
