-- 定义颜色
local colors = {
  bg = "#000000",
  bg_dark = "#0D0D0D",
  bg_float = "#1A1A1A",
  border = "#333333",
  
  -- 主要发光色
  neon_pink = "#FF00FF",
  neon_blue = "#00FFFF",
  neon_green = "#00FF00",
  neon_yellow = "#FFFF00",
  neon_purple = "#9D00FF",
  neon_orange = "#FF6600",
  
  -- 暗色背景光晕
  glow_pink = "#4D004D",
  glow_blue = "#004D4D",
  glow_green = "#004D00",
  glow_yellow = "#4D4D00",
  glow_purple = "#2D004D",
  glow_orange = "#4D2600",
}

-- 定义主题高亮组
local highlights = {
  -- 编辑器UI
  Normal = { fg = "#FFFFFF", bg = colors.bg },
  NormalFloat = { fg = "#FFFFFF", bg = colors.bg_float },
  LineNr = { fg = "#666666", bg = colors.bg_dark },
  CursorLine = { bg = colors.bg_dark },
  CursorColumn = { bg = colors.bg_dark },
  ColorColumn = { bg = colors.bg_dark },
  SignColumn = { bg = colors.bg_dark },
  
  -- 语法高亮
  Keyword = { fg = colors.neon_pink, bg = colors.glow_pink, bold = true },
  Function = { fg = colors.neon_blue, bg = colors.glow_blue, bold = true },
  String = { fg = colors.neon_green, bg = colors.glow_green },
  Comment = { fg = colors.neon_purple, bg = colors.glow_purple, italic = true },
  Type = { fg = colors.neon_yellow, bg = colors.glow_yellow, bold = true },
  Constant = { fg = colors.neon_orange, bg = colors.glow_orange, bold = true },
  
  -- 特殊效果
  Visual = { bg = colors.glow_purple },
  Search = { fg = colors.bg, bg = colors.neon_pink },
  IncSearch = { fg = colors.bg, bg = colors.neon_blue },
  MatchParen = { fg = colors.neon_pink, bg = colors.glow_pink, bold = true },
  
  -- 状态栏
  StatusLine = { fg = "#FFFFFF", bg = colors.bg_float },
  StatusLineNC = { fg = "#999999", bg = colors.bg_float },
  
  -- 其他UI元素
  Pmenu = { fg = "#FFFFFF", bg = colors.bg_float },
  PmenuSel = { fg = colors.bg, bg = colors.neon_blue },
  TabLine = { fg = "#999999", bg = colors.bg_float },
  TabLineSel = { fg = "#FFFFFF", bg = colors.glow_blue },
  
  -- 诊断信息
  DiagnosticError = { fg = colors.neon_pink, bg = colors.glow_pink },
  DiagnosticWarn = { fg = colors.neon_yellow, bg = colors.glow_yellow },
  DiagnosticInfo = { fg = colors.neon_blue, bg = colors.glow_blue },
  DiagnosticHint = { fg = colors.neon_green, bg = colors.glow_green },
}

-- 设置颜色主题
local M = {}

function M.setup()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.g.colors_name = "neon"
  vim.o.termguicolors = true
  vim.o.background = "dark"

  -- 应用高亮组
  for group, attrs in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, attrs)
  end
end

M.setup()

return M