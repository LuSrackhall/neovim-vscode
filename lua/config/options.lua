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

-- 创建自定义的复制高亮组
vim.api.nvim_set_hl(0, 'YankHighlight', {
  bg = '#B8860B',  -- 暗金色
  fg = '#000000',  -- 前景色保持黑色
  blend = 30,      -- 使用 blend 参数来实现透明效果（0-100）
  bold = true,     -- 保持加粗效果
  italic = false,  -- 不使用斜体
  underline = false  -- 不使用下划线
})

-- 禁用 LazyVim 的默认 yank 高亮配置
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    -- 清除所有已存在的 TextYankPost 自动命令
    vim.api.nvim_clear_autocmds({ event = "TextYankPost" })
    
    -- 设置自定义的 yank 高亮
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
      callback = function()
        vim.highlight.on_yank({
          -- higroup = 'IncSearch',  -- 使用 IncSearch 高亮组
          higroup = 'YankHighlight',  -- 使用我们自定义的高亮组
          timeout = 600,  -- 设置为 600 毫秒
          on_macro = true  -- 在宏录制时也显示高亮
        })
      end,
    })
  end,
})
