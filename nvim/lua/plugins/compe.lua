local function init()
    -- Main setup call with config
    local luasnip = require("luasnip")

    require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
            border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
            winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
            max_width = 120,
            min_width = 60,
            max_height = math.floor(vim.o.lines * 0.3),
            min_height = 1,
        };

        source = {
            -- Built-in
            buffer = true;
            calc = true;
            path = true;
            spell = true;
            tags = true;

            -- Neovim
            nvim_lsp = true;
            nvim_lua = true;

            -- External plugin
            luasnip = true;

            -- External source
            -- tabnine = true;
            -- Main reason for slow start up
            -- treesitter = true;
            -- Main reason for slow start up
        };
    }

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder

    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t '<C-n>'
        elseif check_back_space() then
            return t '<Tab>'
        elseif luasnip.expand_or_jumpable() then
            return t '<Plug>luasnip-expand-or-jump'
        else
            return vim.fn['compe#complete']()
        end
    end

    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t '<C-p>'
        elseif luasnip.jumpable(-1) then
            return t '<Plug>luasnip-jump-prev'
        else
            return t '<S-Tab>'
        end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

    -- -- is this necessary?
    -- vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
    -- vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
end

return {
    init = init
}
