return {
  "github/copilot.vim",
  config = function() -- Changed from "setup" to "config"
    vim.g.copilot_no_tab_map = true
    local map = vim.keymap.set
    map("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
}
