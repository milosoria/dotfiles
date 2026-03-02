return {
  -- Mason: ensure tools are installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Go
        "goimports",
        "gofumpt",
        "gopls",

        -- Shell/Bash
        "bash-language-server",
        "shfmt",

        -- Python
        "black",
        "isort",
        "pyright",
        "ruff",

        -- JavaScript/TypeScript
        "eslint-lsp",
        "eslint_d",
        "prettierd",
        "typescript-language-server",

        -- Web
        "json-lsp",
        "tailwindcss-language-server",

        -- Vue
        "vue-language-server",

        -- Lua
        "lua-language-server",
        "stylua",

        -- Markdown
        "markdown-toc",
        "markdownlint-cli2",
        "marksman",
      },
    },
  },

  -- LSP servers configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable gr and K globally (overridden by lspsaga)
        ["*"] = {
          keys = {
            { "gr", false },
            { "K", false },
          },
        },

        -- TypeScript with Vue plugin
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.stdpath("data")
                  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },

        -- Vue Language Server
        vue_ls = {},
      },
    },
  },
}
