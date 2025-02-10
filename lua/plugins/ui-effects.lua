return {
  -- 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true, -- 启用透明背景
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
