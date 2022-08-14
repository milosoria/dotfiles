local function init()
    local gitsigns = require('gitsigns')
    gitsigns.setup()
end

return {
    init = init
}
