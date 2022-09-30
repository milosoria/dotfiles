local function command()
    local filepath = vim.api.nvim_buf_get_name(0)
    local filepath_table = {}
    for word in string.gmatch(filepath, "([^/]+)") do
        filepath_table[#filepath_table + 1] = word
    end
    local filename = filepath_table[#filepath_table]
    -- format string to build command using filename
    local command_string = string.format(":!pdflatex -halt-on-error %s", filename)
    vim.api.nvim_command(command_string)
end

return {
    command = command
}
