local function init()
    require'lualine'.setup{options={theme='tokyonight',component_separators = {'', ''},
    section_separators = {'', ''}, }, sections = {lualine_a = {'mode', 'branch', 'filename'}}}
end

return {
    init=init
}
