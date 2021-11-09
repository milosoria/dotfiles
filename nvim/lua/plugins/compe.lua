local function init()

    -- Main setup call with config
    local luasnip = require("luasnip")
    local lspkind = require('lspkind')
    local cmp = require'cmp'

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
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
    experimental = {
        ghost_text=true
    },
    mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible()  then
        cmp.select_next_item()
      elseif has_words_before() and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) == 1 then
              luasnip.expand_or_jump()
         else
            fallback()
          end
    end, { 'i', 's' }),
      ['<Space>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.close()
              fallback()
           else
               fallback()
           end
      end,{ 'i', 's' }),
      ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and not luasnip.expand_or_jumpable() then
                cmp.complete({ select = true, behavior = cmp.ConfirmBehavior.Replace})
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                cmp.close()
                fallback()
            end
      end, { 'i', 's' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
    },
    documentation = true,
    sources = cmp.config.sources({
            { name = 'nvim_lsp',keyword_length = 3 },
            { name = 'luasnip' }, -- For luasnip users.
            { name = 'buffer',keyword_length = 3 },
            {name ='tags'},
            {name ='path'},
            {name ='calc'},
            {name ='spell'},
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
