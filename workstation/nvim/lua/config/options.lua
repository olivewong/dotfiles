-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- items
vim.g.mapleader = " "
vim.o.swapfile = false
-- make clipboard able to paste everywhere
vim.opt.clipboard = "unnamed"
vim.lsp.set_log_level("info")
