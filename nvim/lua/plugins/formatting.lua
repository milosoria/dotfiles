local function init()

    vim.g.neoformat_only_msg_on_error = 0
    -- Enable alignment
    vim.g.neoformat_basic_format_align = 1

    -- Enable tab to spaces conversion
    vim.g.neoformat_basic_format_retab = 1

    -- Enable trimmming of trailing whitespace
    vim.g.neoformat_basic_format_trim = 1
    vim.g.neoformat_basic_format_align = 1
    vim.g.neoformat_basic_format_trim = 1

    -- Run neoformat and prettier at once
    vim.api.nvim_set_keymap('n', '<Leader>n', '<cmd>Neoformat<CR>',  {noremap = true})

end

return {
    init = init
}
