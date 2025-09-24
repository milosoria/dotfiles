return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
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
        "blackd-client",
        "isort",
        "pyright",
        "python-lsp-server",
        "ruff",

        -- JavaScript/TypeScript
        "eslint-lsp",
        "eslint_d",
        "prettierd",
        "typescript-language-server",

        -- Web
        "json-lsp",
        "tailwindcss-language-server",

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
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
