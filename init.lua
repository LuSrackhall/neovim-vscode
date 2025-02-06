-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  -- 在这里可以设置普通neovim环境下的ctrl+` 打开终端的映射
  vim.keymap.set('n', '<C-`>', '<cmd>ToggleTerm<cr>', { silent = true, desc = "Toggle Terminal" })
end