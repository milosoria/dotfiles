local function init()
    local ok, indentline = pcall(require, "ibl")
    if not ok then
        print("Failed to load indent-blankline")
    end
    indentline.setup()
end

return {
    init = init,
}
