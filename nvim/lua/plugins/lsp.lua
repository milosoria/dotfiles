return {
  "neovim/nvim-lspconfig",
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
    keys[#keys + 1] = {
      "<leader>rn",
      function()
        local inc_rename = require("inc_rename")
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename (inc-rename.nvim)",
      has = "rename",
    }
  end,
}
