local function init()
    local autopairs = require 'nvim-autopairs'
    autopairs.setup {
        disable_filtype = { 'TelescopePrompt', 'vim' }
    }
end

return {
    init = init
}
