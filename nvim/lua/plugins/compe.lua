local function init()

    -- Main setup call with config
    local luasnip = require("luasnip")
    local lspkind = require('lspkind')
    local cmp = require'cmp'

    local has_words_before = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s') 
    end

    cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end

    }, formatting = {
    format = lspkind.cmp_format({with_text = true, menu = ({
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      luasnip = "[LuaSnip]",
      nvim_lua = "[Lua]",
      latex_symbols = "[Latex]",
    })}),
},
    mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() and luasnip.expand_or_jumpable() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '', true)
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) == 1 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '', true)
            else
            fallback()
          end
    end, { 'i', 's' }),
      ['<Space>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.confirm()
           else
               fallback()
           end
      end,{ 'i', 's' }),
      -- ['<CR>'] = cmp.mapping(function(fallback)
      --         if cmp.visible() then
      --             cmp.complete({ select = true, behavior = cmp.ConfirmBehavior.Replace})
      --         else
      --             fallback()
      --         end
      -- end, { 'i', 's' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
    },
    documentation = true,
    sources = cmp.config.sources({     { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
            {name ='calc'},
            {name ='path'},
            {name ='spell'},
            {name ='tags'},
          { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
    })


end

return {
    init = init
}
