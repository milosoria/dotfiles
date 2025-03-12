return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  enabled = function()
    return LazyVim.pick.want() == "telescope"
  end,
  version = false,
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = have_make and "make"
        or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = have_make or have_cmake,
      config = function(plugin)
        LazyVim.on_load("telescope.nvim", function()
          local ok, err = pcall(require("telescope").load_extension, "fzf")
          if not ok then
            local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
            if not vim.uv.fs_stat(lib) then
              LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
              require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
              end)
            else
              LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
            end
          end
        end)
      end,
    },
  },
  keys = {
    -- Custom key mappings as per your requirements
    { "<leader>fg", "<cmd>Telescope live_grep global_pattern='!*.svg' <cr>", desc = "Grep Files" },
    {
      "<leader>p",
      "<cmd>Telescope find_files no_ignore=false hidden=true layout_strategy=vertical<CR>",
      desc = "Find Files with Hidden",
    },
    { "<leader><space>", false },
    { "gr", false },
    { "gd", false },
  },
  opts = function()
    local previewers = require("telescope.previewers")
    local sorters = require("telescope.sorters")
    local actions = require("telescope.actions")
    local actions = require("telescope.actions")

    local open_with_trouble = function(...)
      return require("trouble.sources.telescope").open(...)
    end
    local find_files_no_ignore = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
    end
    local find_files_with_hidden = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { hidden = true, default_text = line })()
    end

    local function find_command()
      if 1 == vim.fn.executable("rg") then
        return { "rg", "--files", "--color", "never", "-g", "!.git" }
      elseif 1 == vim.fn.executable("fd") then
        return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("fdfind") then
        return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
        return { "find", ".", "-type", "f" }
      elseif 1 == vim.fn.executable("where") then
        return { "where", "/r", ".", "*" }
      end
    end
    return {
      pickers = {
        find_files = {
          find_command = find_command,
          hidden = true,
          layout_config = {
            width = 0.5, -- width of the floating window
            height = 0.8, -- height of the floating window
            preview_cutoff = 20, -- set cutoff for preview visibility in smaller windows
            preview_height = 0.2,
          },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" },
          layout_config = {
            width = 0.5, -- width of the floating window
            height = 0.2, -- height of the floating window
          },
          theme = "dropdown",
        },
      },
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        file_ignore_patterns = {
          "%.git",
          ".git/",
          "node_modules",
          "__pycache__",
          "%.png",
          "%.jpeg",
          "%.jpg",
          "%.lock",
          "%.mp3",
          "%.mp4",
        },
        file_sorter = sorters.get_fzy_sorter,
        color_devicons = true,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        initial_mode = "insert",
        -- layout_strategy = "horizontal",

        layout_config = {
          width = 0.70,
          height = 0.60,
          preview_cutoff = 0.8,
        },
        mappings = {
          i = {
            ["<C-t>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
          },
          n = {
            ["q"] = actions.close,
            ["<leader><space>"] = false, -- Disable the default keymap
          },
        },
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case",
      },
    }
  end,
}
