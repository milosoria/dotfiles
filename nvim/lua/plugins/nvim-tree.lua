return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- Must be set before nvim-tree loads to properly disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      local HEIGHT_RATIO = 0.8
      local WIDTH_RATIO = 0.6

      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        auto_reload_on_write = true,
        update_cwd = true,
        hijack_unnamed_buffer_when_opening = true,
        hijack_directories = { enable = true },
        diagnostics = {
          enable = true,
          icons = { hint = "", info = "", warning = "", error = "" },
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
          ignore_list = {},
        },
        filters = { dotfiles = false, custom = {} },
        git = { enable = true, ignore = false, timeout = 500 },
        view = {
          relativenumber = true,
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        trash = { cmd = "trash", require_confirm = true },
        actions = {
          change_dir = { enable = true, global = false },
          open_file = {
            quit_on_open = true,
            resize_window = false,
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        renderer = {
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
              },
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
            },
          },
        },
      })

      -- Open nvim-tree when launching on a directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>:NvimTreeRefresh<CR>", desc = "Toggle File Explorer" },
    },
  },
}
