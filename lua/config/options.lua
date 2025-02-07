-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- 取消动态行号
opt.relativenumber = false

-- 设置剪贴板选项
-- 1. 取消与系统剪贴板的自动同步
opt.clipboard = ""
-- 2. 确保 vim 寄存器独立工作
opt.clipboard:remove({ "unnamed", "unnamedplus" })
