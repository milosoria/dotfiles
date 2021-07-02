local function init()
    vim.g.neoformat_only_msg_on_error = 0
    vim.g.neoformat_run_all_formatters = 1
    vim.g.neoformat_basic_format_align = 1
    vim.g.neoformat_basic_format_trim = 1
end
return {
    init = init
}
