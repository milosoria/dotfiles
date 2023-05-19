local function init()
    local nvim_tree_events = require("nvim-tree.events")
    local bufferline_api = require("bufferline.api")

    local function get_tree_size()
        return require("nvim-tree.view").View.width
    end

    nvim_tree_events.subscribe("TreeOpen", function()
        bufferline_api.set_offset(get_tree_size())
    end)

    nvim_tree_events.subscribe("Resize", function()
        bufferline_api.set_offset(get_tree_size())
    end)

    nvim_tree_events.subscribe("TreeClose", function()
        bufferline_api.set_offset(0)
    end)
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    local ok, bufferline = pcall(require, "bufferline")

    if not ok then
        print("Failed to load barbar or nvim-web-devicons")
        return
    end

    -- Move to previous/next
    map("n", "<leader>h", "<Cmd>BufferPrevious<CR>", opts)
    map("n", "<leader>l", "<Cmd>BufferNext<CR>", opts)
    -- Re-order to previous/next
    map("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", opts)
    map("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", opts)
    -- Goto buffer in position...
    map("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", opts)
    map("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", opts)
    map("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", opts)
    map("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", opts)
    map("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", opts)
    map("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", opts)
    map("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", opts)
    map("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", opts)
    map("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", opts)
    map("n", "<leader>0", "<Cmd>BufferLast<CR>", opts)
    -- Close buffer
    map("n", "<leader>bc", "<Cmd>BufferClose<CR>", opts)
    map("n", "<leader>bq", "<Cmd>wall<CR> <Cmd>BufferCloseAllButCurrent<CR>", opts)
    -- Set barbar's options
    bufferline.setup({
        -- Enable/disable animations
        animation = true,
        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = false,
        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,
        -- Enable/disable close button
        closable = true,
        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,
        -- Excludes buffers from the tabline
        exclude_ft = {},
        exclude_name = {},
        -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
        hide = { extensions = false, inactive = false },
        -- Disable highlighting alternate buffers
        highlight_alternate = false,
        -- Disable highlighting file icons in inactive buffers
        highlight_inactive_file_icons = false,
        -- Enable highlighting visible buffers
        highlight_visible = true,
        -- Enable/disable icons
        -- if set to 'numbers', will show buffer index in the tabline
        -- if set to 'both', will show buffer index and icons in the tabline
        icons = { -- Configure the base icons on the bufferline.
            buffer_index = false,
            buffer_number = false,
            button = "",
            -- Enables / disables diagnostic symbols
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
                [vim.diagnostic.severity.WARN] = { enabled = false },
                [vim.diagnostic.severity.INFO] = { enabled = false },
                [vim.diagnostic.severity.HINT] = { enabled = true },
            },
            filetype = {
                -- Sets the icon's highlight group.
                -- If false, will use nvim-web-devicons colors
                custom_colors = false,

                -- Requires `nvim-web-devicons` if `true`
                enabled = true,
            },
            separator = { left = "▎", right = "" },

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = { button = "●" },
            pinned = { button = "車" },

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = { filetype = { enabled = false } },
            current = { buffer_index = true },
            inactive = { button = "×" },
            visible = { modified = { buffer_number = false } },
        },
        -- If set, the icon color will follow its corresponding buffer
        -- highlight group. By default, the Buffer*Icon group is linked to the
        -- Buffer* group (see Highlighting below). Otherwise, it will take its
        -- default value as defined by devicons.
        icon_custom_colors = false,
        -- If true, new buffers will be inserted at the start/end of the list.
        -- Default is to insert after current buffer.
        insert_at_end = false,
        insert_at_start = false,
        -- Sets the maximum padding width with which to surround each tab
        maximum_padding = 1,
        -- Sets the minimum padding width with which to surround each tab
        minimum_padding = 1,
        -- Sets the maximum buffer name length.
        maximum_length = 30,
        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,
        -- New buffer letters are assigned in this order. This order is
        -- optimal for the qwerty keyboard layout but might need adjustement
        -- for other layouts.
        letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
        -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
        -- where X is the buffer number. But only a static string is accepted here.
        no_name_title = nil,
    })
end

return {
    init = init,
}
