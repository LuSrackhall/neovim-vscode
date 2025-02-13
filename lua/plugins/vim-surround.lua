return {
  "tpope/vim-surround",
  event = "VeryLazy",
  -- 确保在 VSCode 中也启用
  vscode = true,
}

-- 可视模式下: 选中文本后按 S + 符号 可以给选中内容添加符号
-- 普通模式下: ys + 移动/文本对象 + 符号 添加符号 (例如 ysiw" 给当前单词添加双引号)
-- ds + 符号 删除符号
-- cs + 旧符号 + 新符号 更改符号
-- 这些操作还会通过 vscode-neovim 插件在 VSCode 中生效