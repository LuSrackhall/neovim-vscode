-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function is_vscode()
  return vim.g.vscode ~= nil
end

-- 禁用 LazyVim 默认的 <C-/> 映射（打开终端）
vim.keymap.del("n", "<C-/>")

-- 设置 <C-/> 映射
vim.keymap.set("n", "<C-/>", function()
  if is_vscode() then
    -- 在 VSCode 环境下调用 VSCode 的注释命令
    --------------------------------------------------------------------------------------------------
    -- require('vscode-neovim').call('editor.action.commentLine') -- 'vscode-neovim' 的模块现在已经弃用了, 由'vscode' 模块替代。
    require('vscode').call('editor.action.commentLine')
    --------------------------------------------------------------------------------------------------
  else

    -- 在普通 Neovim 环境下使用 vim 的注释功能
    vim.cmd('normal gcc')  -- 需要确保安装了 Comment.nvim 插件
  end
end, { silent = true, desc = "Toggle Comment" })

-- 仅在非 VSCode 环境下设置终端快捷键
if not is_vscode() then
  vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<cr>", { silent = true, desc = "Toggle Terminal" })
end
