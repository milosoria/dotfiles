return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bq", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<leader>bc", "<Cmd>bd<CR>", desc = "Close current buffer" },
    { "<leader>h", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<leader>l", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    { "<leader>1", "<cmd>lua require('bufferline').go_to(1, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>2", "<cmd>lua require('bufferline').go_to(2, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>3", "<cmd>lua require('bufferline').go_to(3, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>4", "<cmd>lua require('bufferline').go_to(4, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>5", "<cmd>lua require('bufferline').go_to(5, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>6", "<cmd>lua require('bufferline').go_to(6, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>7", "<cmd>lua require('bufferline').go_to(7, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>8", "<cmd>lua require('bufferline').go_to(8, true)<cr>", desc = "Go to specific buffer" },
    { "<leader>9", "<cmd>lua require('bufferline').go_to(9, true)<cr>", desc = "Go to specific buffer" },
  },
  opts = {
    options = {
      numbers = "ordinal",
      -- stylua: ignore
      close_command = function(n) LazyVim.ui.bufremove(n) end,
      -- stylua: ignore
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
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
