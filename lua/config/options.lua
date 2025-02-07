-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- 取消动态行号
opt.relativenumber = false

-- 取消与系统剪贴板的同步(若需要同步, 则注释掉此行即可)
vim.opt.clipboard = ""
