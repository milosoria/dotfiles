-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set indent character list for indent plugin
vim.g.indentLine_char_list = { "|", "¦", "┆", "┊" }

-- LaTeX flavor setting
vim.g.tex_flavor = "latex"

-- Leader key setup
vim.g.mapleader = " "

-- Status line behavior for last window
vim.o.laststatus = 3
vim.o.eadirection = "ver"
vim.o.wildmode = "longest,full"
vim.o.wildmenu = true
vim.o.relativenumber = false

-- Indentation settings
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = false
vim.o.smartindent = true

-- Text formatting
vim.o.textwidth = 100
vim.o.wrap = false
vim.g.showbreak = "↪"

-- Display and search options
vim.o.hlsearch = false
vim.o.nu = true
vim.o.hidden = true
vim.o.errorbells = false
vim.o.ignorecase = false
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.incsearch = true
vim.o.guicursor = "i:ver100-icursor"
vim.o.scrolloff = 8
vim.o.sidescroll = 2
vim.o.signcolumn = "no"
vim.o.completeopt = "menuone,noselect"
vim.o.numberwidth = 3
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.termguicolors = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.syntax = "off"

-- Conceal settings for JSON and Markdown
vim.g.conceallevel = 0
vim.g.nowrap = true

-- Adjust shada file path
local current_shada = vim.opt.shada:get()
table.insert(current_shada, "r/mnt/exdisk")
vim.opt.shada = current_shada
vim.g.open_in_insert_mode = 1
vim.g.preserve_alternate_buffer = 1
vim.g.autoformat = false
vim.o.ttyfast = true
