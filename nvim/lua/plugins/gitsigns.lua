local function init()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
        print("Failed to load gitsigns")
        return
    end
    gitsigns.setup()
end

return {
    init = init,
}
