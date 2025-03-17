-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Filename: keymaps.lua
local map = vim.keymap.set
local settings = { noremap = true }
-- Alt moving lines
map("n", "<A-j>", ":m .+1<CR>==", settings)
map("n", "<A-k>", ":m .-2<CR>==", settings)
map("n", "<A-j>", ":m '>+1<CR>gv=gv", settings)
map("n", "<A-k>", ":m '<-2<CR>gv=gv", settings)

-- Resizing
map("n", "<leader>+", ":vertical resize +10<CR>", settings)
map("n", "<leader>-", ":vertical resize -10<CR>", settings)
map("n", "<leader>=", "<C-W>= <CR>", settings)

-- Force quit
map("n", "<leader>q", ":q!<CR>", settings)

-- Indenting with builtin
map("n", "<leader>i", "ma :norm gg=G<CR> `a", settings)

-- Remap C-W C-O to <leader>w
map("n", "<Leader>w", "<C-W><C-O>", settings)

-- Remap to indent with one keystroke
map("n", ">", ">>", settings)
map("n", "<", "<<", settings)

-- Terminal escape key
map("t", "<Esc>", "<C-\\><C-n>", settings)

-- QuickFixList navigation
map("n", "<leader>cn", ":cn<CR>", settings)
map("n", "<leader>cp", ":cp<CR>", settings)
map("n", "<leader>cq", ":ccl<CR>", settings)

-- Close buffer without quitting
map("n", "<leader>cc", ":close<CR>", settings)

-- Paste over word but maintain your paste register
map("v", "<leader>p", '"_dP', settings)

-- Delete but maintain your paste register
map("v", "<leader>d", '"_d', settings)
map("n", "<leader>d", '"_d', settings)

-- Split windows
map("n", "<leader>s\\", "<C-w>v", settings)
map("n", "<leader>s-", "<C-w>s", settings)
map("n", "<leader>se", "<C-w>=", settings)
map("n", "<leader>sc", ":close <CR>", settings)

-- Maximize window and restore
map("n", "<leader>sm", ":MaximizerToggle<CR>", settings)
map("n", "<Leader>tt", ":ToggleTerminal<CR>", settings)
map("n", "<Leader>t\\", ":vsplit | :ToggleTerminal<CR>", settings)
map("n", "<Leader>t-", ":split<CR>|:resize -10<CR>|:ToggleTerminal<CR>", settings)

-- Change background light/dark
map("n", "<leader>bg", function()
  if vim.o.background == "dark" then
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_foreground = "material"
    vim.cmd([[ set background=light]])
  else
    vim.cmd([[ set background=dark]])
  end
  -- Reapply the colorscheme
  vim.cmd("colorscheme gruvbox-material")
end, settings)

-- Keymap to toggle background

-- formatting
map({ "n", "v" }, "<leader>n", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })


-- delete default keymaps
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
