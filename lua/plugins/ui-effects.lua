return {
  -- 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true, -- 启用透明背景(否则只有亚克力效果, 我们需要透明背景将其变为毛玻璃)
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  
  -- 光标增强
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      fancy = {
        enable = true,
        head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
        body = {
          { cursor = "", texthl = "SmoothCursorRed" },
          { cursor = "", texthl = "SmoothCursorOrange" },
          { cursor = "●", texthl = "SmoothCursorYellow" },
          { cursor = "●", texthl = "SmoothCursorGreen" },
          { cursor = "•", texthl = "SmoothCursorAqua" },
          { cursor = ".", texthl = "SmoothCursorBlue" },
          { cursor = ".", texthl = "SmoothCursorPurple" },
        },
      },
    },
    config = function(_, opts)
      require("smoothcursor").setup(opts)
      
      -- 添加光标颜色高亮组
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#FFD400" })
      vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = "#FF0000" })
      vim.api.nvim_set_hl(0, "SmoothCursorOrange", { fg = "#FFA500" })
      vim.api.nvim_set_hl(0, "SmoothCursorYellow", { fg = "#FFFF00" })
      vim.api.nvim_set_hl(0, "SmoothCursorGreen", { fg = "#00FF00" })
      vim.api.nvim_set_hl(0, "SmoothCursorAqua", { fg = "#00FFFF" })
      vim.api.nvim_set_hl(0, "SmoothCursorBlue", { fg = "#0000FF" })
      vim.api.nvim_set_hl(0, "SmoothCursorPurple", { fg = "#FF00FF" })
    end,
  },

  -- 荧光笔效果
  {
    "folke/paint.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      highlights = {
        -- 添加更多显眼的发光效果
        {
          filter = { filetype = "lua" },
          pattern = "%-%-.*",
          hl = "GlowComment",
        },
        {
          filter = { filetype = "lua" },
          pattern = "function",
          hl = "GlowKeyword",
        },
        {
          filter = { filetype = "lua" },
          pattern = "return",
          hl = "GlowReturn",
        },
        {
          filter = { filetype = "lua" },
          pattern = "require",
          hl = "GlowRequire",
        },
      },
    },
    config = function(_, opts)
      -- 设置发光效果的高亮组
      -- 设置更亮的发光效果
      vim.api.nvim_set_hl(0, "GlowComment", { fg = "#7dcfff", bold = true, italic = true })
      vim.api.nvim_set_hl(0, "GlowKeyword", { fg = "#ff79c6", bold = true })
      vim.api.nvim_set_hl(0, "GlowReturn", { fg = "#f1fa8c", bold = true })
      vim.api.nvim_set_hl(0, "GlowRequire", { fg = "#50fa7b", bold = true })
      require("paint").setup(opts)
    end,
  },
}

-- LazyVim中切换主题很简单，使用:colorscheme命令：

-- 查看所有可用主题：
-- * :colorscheme 然后先按 空格 再按 Tab 键，会显示所有已安装的主题

-- 切换到特定主题：

-- :colorscheme tokyonight - 切换到 Tokyo Night（默认主题）
-- :colorscheme catppuccin - 切换到 Catppuccin ()
-- :colorscheme habamax - 切换到 Habamax
-- 主题变体：
-- Tokyo Night 变体：

-- :colorscheme tokyonight-night - 深色版本
-- :colorscheme tokyonight-storm - 稍微亮一点的深色
-- :colorscheme tokyonight-day - 浅色版本
-- :colorscheme tokyonight-moon - 高对比度版本
-- Catppuccin 变体：

-- :colorscheme catppuccin-mocha - 深色版本
-- :colorscheme catppuccin-macchiato - 中等深色
-- :colorscheme catppuccin-frappe - 柔和深色
-- :colorscheme catppuccin-latte - 浅色版本
--
-- 如果你想将某个主题设为默认，可以在 lua/config/options.lua 中添加：
--
-- vim.cmd.colorscheme "catppuccin"  -- 或其他主题名
-- vim.cmd.colorscheme("catppuccin") -- lua 中的调用方式
--
-- 如果你和我一样, 在lua/config/options.lua 使用代码后没有生效, 则可参考本次提交中我的做法, 直接在主题插件的配置文件内, 定义默认主题(ai帮忙搞的哈哈)。