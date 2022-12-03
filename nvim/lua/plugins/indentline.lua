local function init()
    local ok, indentline = pcall(require, "indent_blankline")
    indentline.setup({
        -- for example, context is off by default, use this to turn it on
        show_current_context = true,
        show_current_context_start = false,
    })
end

return {
    init = init,
}
