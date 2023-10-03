-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Vertical split window
vim.api.nvim_set_keymap("n", "<leader>vs", ":vsp<CR>", { noremap = true })

-- Horizontal split window
vim.api.nvim_set_keymap("n", "<leader>sp", ":sp<CR>", { noremap = true })

-- Go to the window on the left ;
vim.api.nvim_set_keymap("n", "<leader>;", "<C-W>h", { noremap = true })

-- Go to the window on the right '
vim.api.nvim_set_keymap("n", "<leader>'", "<C-W>l", { noremap = true })

-- Run Neoformat for current buffer
vim.api.nvim_set_keymap("n", "<leader>pr", ":Neoformat<CR>", { noremap = true })

-- Save current file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true })

-- Save and quit current file
vim.api.nvim_set_keymap("n", "<leader>wq", ":wq<CR>", { noremap = true })

-- SEARCH
-- C-P classic find file
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-P>", builtin.find_files, {})
-- Word under cursor
vim.keymap.set("n", "<leader>ag", builtin.grep_string, {})
