local function init()
    local ok, colorizer = pcall(require, "colorizer")
    if not ok then
        print("Failed to load colorizer")
        return
    end
    colorizer.setup()
end

return {
    init = init,
}
