local function init()

    --editor configs
    vim.g.cmdheight=1
    vim.g.eadirection='ver'
    vim.g.wildmode='longest,full'
    vim.g.wildmenu=1
    vim.g.relativenumber=1
    vim.g.shell='/usr/bin/zsh'

    -- number of visual spaces per tab
    vim.g.tabstop=8
    -- number of spaces to use for each step if (auto)indent
    vim.g.shiftwidth=4
    -- number of spaces inserted when tab is pressed in insert mode
    vim.g.softtabstop=0

    -- insert spaces when pressing tab
    vim.g.expandtab=1
    vim.g.smarttab=1

    -- autoindent
    vim.g.autoindent=1

    vim.g.textwidth=100

    -- if wrap is vim.g., then showbreak adds a string to lines wrapped
    vim.g.nowrap=1
    vim.g.showbreak='↪'

    vim.g.smartindent=1
    vim.g.nohlsearch=1
    vim.g.nu=1
    vim.g.hidden=1
    vim.g.noerrorbells=1
    vim.g.smartcase=1
    vim.g.noswapfile=1
    vim.g.incsearch=1
    vim.g.guicursor='a:blinkon80,i:ver100-icursor'
    vim.g.scrolloff=8
    vim.g.sidescroll=2
    vim.g.signcolumn='auto'
    vim.g.completeopt='menuone,noselect'
    vim.g.numberwidth=3
    vim.g.shortmess='c'
    vim.g.clipboard='unnamedplus'
    vim.g.mouse='a'
    vim.g.termguicolors=1
    vim.g.splitright=1
    vim.g.splitbelow=1
end

return {
    init = init
}
