local function init()
    local ok, autotags = pcall(require, "nvim-ts-autotag")
    if not ok then
        print("Failed to load nvim-autotag")
        return
    end
    autotags.setup()
end

return {
    init = init,
}
