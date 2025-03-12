local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    enabled = true,
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.experimental = {
        ghost_text = true,
      }
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-y>"] = function() end,
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() ~= nil then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
          else
            cmp.close()
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.close(),
      })
      -- Remove snippet source if present
      opts.sources = vim.tbl_filter(
        function(source)
          return source.name ~= "snippets"
        end,
        cmp.config.sources({
          { name = "lazydev" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        })
      )

      -- table.insert(opts.sources, 1, {
      --   name = "copilot",
      --   group_index = 1,
      --   priority = 100,
      -- })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    enabled = false,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },

      documentation = {
        auto_show = false,
        auto_show_delay_ms = 200,
      },
    },
    signature = {
      enabled = false,
      trigger = {
        -- Show the signature help automatically
        enabled = true,
        -- Show the signature help window after typing any of alphanumerics, `-` or `_`
        show_on_keyword = false,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        -- Show the signature help window after typing a trigger character
        show_on_trigger_character = true,
        -- Show the signature help window when entering insert mode
        show_on_insert = false,
        -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
      },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },
        list = {
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = true,
            -- When `true`, inserts the completion item automatically when selecting it
            auto_insert = true,
          },
        },
        -- Whether to automatically show the window when new completion items are available
        menu = { auto_show = true },
        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = false },
      },
    },
    opts = {
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = "none",

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          "select_next",
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "fallback",
        },
        ["<C-D>"] = { "scroll_documentation_down", "fallback" },
        ["<C-U>"] = { "scroll_documentation_up", "fallback" },
        ["<C-y>"] = {},

        -- show with a list of providers
        ["<C-space>"] = {
          function(cmp)
            cmp.hide()
          end,
        },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "buffer" },
      },
      cmdline = {
        enabled = false,
      },
    },
  },
}
