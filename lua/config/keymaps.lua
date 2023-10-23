-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- for repository page
vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>", { silent = true, noremap = true })

-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>gf", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })
