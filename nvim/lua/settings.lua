-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- indent plug
vim.g.indentLine_char_list = { "|", "¦", "┆", "┊" }

-- Latex flavor, in order to make the FileType be a latex and not plaintex
vim.g.tex_flavor = "latex"

-- set leader key
vim.g.mapleader = " "
-- The value of this option influences when the last window will have a
-- status line:
vim.o.laststatus = 3
vim.o.eadirection = "ver"
vim.o.wildmode = "longest,full"
vim.o.wildmenu = true
vim.o.relativenumber = true

-- number of visual spaces per tab
vim.o.tabstop = 8
-- number of spaces to use for each step if (auto)indent
vim.o.shiftwidth = 4
-- number of spaces inserted when tab is pressed in insert mode
vim.o.softtabstop = 0
-- insert spaces when pressing tab
vim.o.expandtab = true
vim.o.smarttab = true
-- autoindent
vim.o.autoindent = true
vim.o.textwidth = 100
-- no line wrapping
vim.o.wrap = false
vim.g.showbreak = "↪"
vim.o.smartindent = true
vim.o.hlsearch = false
vim.o.nu = true
vim.o.hidden = true
vim.o.errorbells = false
vim.o.ignorecase = false
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.incsearch = true
vim.o.guicursor = "a:blinkon80,i:ver100-icursor"
vim.o.scrolloff = 8
vim.o.sidescroll = 2
vim.o.signcolumn = "auto"
vim.o.completeopt = "menuone,noselect"
vim.o.numberwidth = 3
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.termguicolors = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.syntax = "off"
-- show double quotes in json or stars on markdown
vim.g.conceallevel = 0
