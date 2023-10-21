-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local undodir = vim.fn.stdpath("config") .. "/undodir"

if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- Set undodir and enable undofile
vim.opt.undodir = undodir
vim.opt.undofile = true
