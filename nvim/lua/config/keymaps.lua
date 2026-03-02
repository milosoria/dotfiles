-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true }

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Vertical resize / equalize
map("n", "<leader>+", ":vertical resize +10<CR>", opts)
map("n", "<leader>-", ":vertical resize -10<CR>", opts)
map("n", "<leader>=", "<C-W>=<CR>", opts)

-- Force quit
map("n", "<leader>q", ":q!<CR>", opts)

-- Split windows
map("n", "<leader>s\\", "<C-w>v", opts)
map("n", "<leader>s-", "<C-w>s", opts)
map("n", "<leader>se", "<C-w>=", opts)
map("n", "<leader>sc", ":close<CR>", opts)

-- Buffer navigation
map("n", "<leader>h", "<cmd>BufferLineCyclePrev<cr>", opts)
map("n", "<leader>l", "<cmd>BufferLineCycleNext<cr>", opts)

-- Indent/dedent in normal mode
map("n", ">", ">>", opts)
map("n", "<", "<<", opts)

-- Terminal: exit to normal mode
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Format
map({ "n", "v" }, "<leader>n", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

-- Inc-rename
map("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

-- Close all other windows
map("n", "<leader>w", "<C-W><C-O>", opts)

-- Maximize/restore window
map("n", "<leader>sm", ":MaximizerToggle<CR>", opts)

-- QuickFix navigation
map("n", "<leader>cn", ":cn<CR>", opts)
map("n", "<leader>cp", ":cp<CR>", opts)
map("n", "<leader>cq", ":ccl<CR>", opts)

-- Paste over selection without losing register
map("v", "<leader>p", '"_dP', opts)

-- Delete without yanking
map("v", "<leader>d", '"_d', opts)
map("n", "<leader>d", '"_d', opts)

--Delete default LazyVim keymaps that conflict
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
