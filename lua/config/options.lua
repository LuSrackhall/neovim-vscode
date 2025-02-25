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


-- -- 创建自定义的复制高亮组
-- vim.api.nvim_set_hl(0, 'YankHighlight', {
--   bg = '#B8860B',  -- 暗金色
--   -- fg = '#000000',  -- 前景色保持黑色
--   blend = 30,      -- 使用 blend 参数来实现透明效果（0-100）
--   bold = true,     -- 保持加粗效果
--   italic = false,  -- 不使用斜体
--   underline = false  -- 不使用下划线
-- })

-- 禁用 LazyVim 的默认 yank 高亮配置
vim.api.nvim_create_autocmd("User", {
  callback = function()
    -- 清除所有已存在的 TextYankPost 自动命令
    vim.api.nvim_clear_autocmds({ event = "TextYankPost" })
    
    -- 设置自定义的 yank 高亮
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
      callback = function()
        vim.highlight.on_yank({
          higroup = 'IncSearch',  -- 使用 IncSearch 高亮组
          -- higroup = 'YankHighlight',  -- 使用我们自定义的高亮组
          timeout = 1000,  -- 设置为 600 毫秒
          on_macro = true  -- 在宏录制时也显示高亮
        })
      end,
    })
  end,
})