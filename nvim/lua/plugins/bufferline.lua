return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bq", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close Buffers to the Left" },
    { "<leader>bc", "<Cmd>bd<CR>", desc = "Close Current Buffer" },
    { "<leader>h", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<leader>l", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>1", "<cmd>lua require('bufferline').go_to(1, true)<cr>", desc = "Buffer 1" },
    { "<leader>2", "<cmd>lua require('bufferline').go_to(2, true)<cr>", desc = "Buffer 2" },
    { "<leader>3", "<cmd>lua require('bufferline').go_to(3, true)<cr>", desc = "Buffer 3" },
    { "<leader>4", "<cmd>lua require('bufferline').go_to(4, true)<cr>", desc = "Buffer 4" },
    { "<leader>5", "<cmd>lua require('bufferline').go_to(5, true)<cr>", desc = "Buffer 5" },
    { "<leader>6", "<cmd>lua require('bufferline').go_to(6, true)<cr>", desc = "Buffer 6" },
    { "<leader>7", "<cmd>lua require('bufferline').go_to(7, true)<cr>", desc = "Buffer 7" },
    { "<leader>8", "<cmd>lua require('bufferline').go_to(8, true)<cr>", desc = "Buffer 8" },
    { "<leader>9", "<cmd>lua require('bufferline').go_to(9, true)<cr>", desc = "Buffer 9" },
  },
  opts = {
    options = {
      numbers = "ordinal",
      close_command = function(n) LazyVim.ui.bufremove(n) end,
      right_mouse_command = function(n) LazyVim.ui.bufremove(n) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}
