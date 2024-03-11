-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- disable layzyterm keymap
vim.api.nvim_del_keymap("n", "<c-/>")
vim.api.nvim_del_keymap("n", "<c-_>")
-- remap lazyterm keymap
vim.api.nvim_set_keymap("n", "<c-/>", ":ToggleTerm<CR>", { noremap = true, silent = true })
