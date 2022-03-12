local function init()

    require'lualine'.setup({
        options={
            theme='palenight',
            component_separators = {'', ''},
            section_separators = {'', ''}
        },
        section_b = {
            'branch',
            'diff',
            'diagnostics',
            sources={'nvim_lsp', 'coc' }
    }
})

end

return {
    init=init
}
