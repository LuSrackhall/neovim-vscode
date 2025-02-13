-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Enable terminal true color
opt.termguicolors = true

-- Visual enhancement
opt.cursorline = true
opt.cursorcolumn = false
opt.colorcolumn = "80"
opt.synmaxcol = 200

-- Windows Terminal optimization
if vim.fn.has("win32") == 1 then
  -- Set COLORTERM
  vim.env.COLORTERM = "truecolor"
  
  -- Optimize display refresh
  opt.redrawtime = 1000
  
  -- Set darker background for glow effect
  vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
end

-- Disable relative line numbers
opt.relativenumber = false

-- Clipboard options
opt.clipboard = ""
opt.clipboard:remove({"unnamed", "unnamedplus"})

-- ShaDa file optimization
opt.shada = ""  -- Disable shada file
vim.schedule(function()
  vim.cmd([[silent! rshada]])  -- Read shada file silently
end)
