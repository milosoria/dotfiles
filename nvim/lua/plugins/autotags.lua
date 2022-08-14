local function init()
    local autotags = require 'nvim-ts-autotag'
    autotags.setup()
end

return {
    init = init
}
