-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "

-- Disable autoformat
vim.g.autoformat = false

-- Disable animations
vim.g.snacks_animate = false

-- Indentation
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = false

-- Display
vim.o.relativenumber = false
vim.o.nu = true
vim.o.signcolumn = "no"
vim.o.numberwidth = 3
vim.o.scrolloff = 8
vim.o.sidescroll = 2
vim.o.wrap = false
vim.o.textwidth = 100

-- Search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = false
vim.o.smartcase = true

-- Misc
vim.o.swapfile = false
vim.o.hidden = true
vim.o.errorbells = false
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.completeopt = "menuone,noselect"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.laststatus = 3
vim.o.guicursor = "i:ver100-icursor"
vim.o.ttyfast = true
