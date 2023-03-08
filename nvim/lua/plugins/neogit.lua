local function init()
    local ok, neogit = pcall(require, "neogit")
    if not ok then
        print("Neogit not installed")
        return
    end
    neogit.setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        -- customize displayed signs
        signs = {
            -- { CLOSED, OPENED }
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
        },
        integrations = {
            diffview = true,
        },
    })
end

return {
    init = init,
}
