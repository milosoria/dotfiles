local function init()

    require'lualine'.setup({
        options={
            theme='palenight',
            component_separators = {'', ''},
            section_separators = {'', ''}
        },
    })

end

return {
    init=init
}
