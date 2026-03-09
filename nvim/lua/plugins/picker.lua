return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
    picker = {
      win = {
        input = {
          keys = {
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  keys = {
    -- Remap <leader>fg from git files to live grep
    { "<leader>fg", false },
    {
      "<leader>fg",
      function() Snacks.picker.grep() end,
      desc = "Grep",
    },
    -- Add <leader>p for find files in cwd (not git root)
    {
      "<leader>p",
      function() Snacks.picker.files({ cwd = vim.uv.cwd() }) end,
      desc = "Find Files (cwd)",
    },
  },
}
