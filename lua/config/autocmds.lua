-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- 注册颜色主题到补全系统
local color_list = vim.fn.getcompletion("", "color")
if not vim.tbl_contains(color_list, "neon") then
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    pattern = "*",
    callback = function()
      vim.fn.execute("silent! packadd neon")
    end,
  })
end

if not vim.tbl_contains(color_list, "catppuccin") then
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    pattern = "*",
    callback = function()
      vim.fn.execute("silent! packadd catppuccin")
    end,
  })
end

-- 创建用于补全的命令
vim.api.nvim_create_user_command("Colors", function()
  local colors = vim.fn.getcompletion("", "color")
  vim.ui.select(colors, {
    prompt = "Select colorscheme:",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice then
      vim.cmd.colorscheme(choice)
    end
  end)
end, {})
