-- UI效果增强配置
return {
  -- smoothcursor.nvim：高级光标动画效果
  {
    "gen740/smoothcursor.nvim",
    event = "VeryLazy",
    config = function()
      require('smoothcursor').setup({
        -- 动画类型：
        -- "default" - 线性动画
        -- "exp"     - 指数动画（加速度）
        -- "matrix"  - 矩阵风格
        type = "exp",    

        -- 光标形状和拖尾符号
        cursor = "",    -- 主光标
        texthl = "SmoothCursor",  -- 光标的高亮组
        fancy = {
          enable = true,          -- 启用花哨模式
          head = { cursor = "▷", texthl = "SmoothCursor" },  -- 头部光标
          body = {
            -- 拖尾的渐变符号
            { cursor = "●", texthl = "SmoothCursorRed" },
            { cursor = "●", texthl = "SmoothCursorOrange" },
            { cursor = "•", texthl = "SmoothCursorYellow" },
            { cursor = "•", texthl = "SmoothCursorGreen" },
            { cursor = "∙", texthl = "SmoothCursorAqua" },
            { cursor = "∙", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
        },

        speed = 25,            -- 动画速度 (更小 = 更快)
        intervals = 35,        -- 刷新间隔 (更小 = 更流畅，但更耗性能)
        priority = 10,         -- 渲染优先级
        timeout = 3000,        -- 超时时间，设置较大值使拖尾持久
        threshold = 0,         -- 设置触发动画的最小行数为1
        enabled = true,
        
        disabled_filetypes = { -- 在这些文件类型中禁用
          "lazy",
          "TelescopePrompt",
        },
      })

      -- 设置光标和拖尾的颜色
      local colors = {
        red = "#FF5555",
        orange = "#FFB86C",
        yellow = "#F1FA8C",
        green = "#50fa7b",
        aqua = "#8BE9FD",
        blue = "#BD93F9",
        purple = "#FF79C6",
      }

      -- 设置主光标颜色
      vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = colors.purple, bold = true })

      -- 设置拖尾渐变色
      vim.api.nvim_set_hl(0, 'SmoothCursorRed', { fg = colors.red })
      vim.api.nvim_set_hl(0, 'SmoothCursorOrange', { fg = colors.orange })
      vim.api.nvim_set_hl(0, 'SmoothCursorYellow', { fg = colors.yellow })
      vim.api.nvim_set_hl(0, 'SmoothCursorGreen', { fg = colors.green })
      vim.api.nvim_set_hl(0, 'SmoothCursorAqua', { fg = colors.aqua })
      vim.api.nvim_set_hl(0, 'SmoothCursorBlue', { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'SmoothCursorPurple', { fg = colors.purple })
    end
  },

  -- indent-blankline：优化的缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      -- 创建高亮配置函数
      local function set_ibl_highlights()
        -- 缩进线颜色
        vim.api.nvim_set_hl(0, "GlowIndent1", { fg = "#7aa2f7", nocombine = true })
        vim.api.nvim_set_hl(0, "GlowIndent2", { fg = "#bb9af7", nocombine = true })
        -- 范围指示线颜色
        vim.api.nvim_set_hl(0, "GlowScope", { fg = "#7dcfff", nocombine = true })
      end

      -- 初始设置高亮
      set_ibl_highlights()

      -- 在主题改变时重新设置高亮
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          set_ibl_highlights()
        end,
      })

      -- 基础配置
      local config = {
        enabled = true,
        indent = {
          char = "│",
          highlight = { "GlowIndent1", "GlowIndent2" },
        },
        scope = {
          enabled = true,
          char = "│",
          show_start = false,
          show_end = false,
          highlight = "GlowScope",
          priority = 500,
        },
      }

      -- 初始化插件
      require("ibl").setup(config)
    end,
  },

  -- Catppuccin主题：现代化的配色方案
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,     -- 立即加载主题
    priority = 1000,  -- 高优先级确保主题被优先加载
    opts = {
      flavour = "mocha",  -- 使用深色主题
      transparent_background = true,  -- 启用透明背景
      styles = {
        comments = { "italic" },      -- 注释使用斜体
        conditionals = { "italic" },  -- 条件语句使用斜体
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
      
      -- Neovide专用配置
      if vim.g.neovide then
        -- 字体设置
        vim.o.guifont = "DepartureMono Nerd Font Mono"  -- 使用Nerd Font以支持图标
        
        -- 基础光标设置
        vim.g.neovide_cursor_animation_length = 0.1  -- 快速的光标动画
        vim.g.neovide_cursor_trail_length = 0.5     -- 适中的拖尾长度
        vim.g.neovide_cursor_vfx_mode = "sonicboom" -- 经典的光标特效
        
        -- 窗口设置
        vim.g.neovide_transparency = 0.9  -- 轻度透明效果
      end
    end,
  },

  -- bufferline.nvim：优化的标签栏
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true, -- 这个选项控制是否始终显示标签栏
      },
    },
  },
}
