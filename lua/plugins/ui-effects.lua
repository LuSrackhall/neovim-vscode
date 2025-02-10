-- UI效果增强配置
return {
  -- indent-blankline: 缩进线和代码块范围显示
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",  -- 延迟加载以提高启动速度
    main = "ibl",        -- 主模块名称
    opts = {
      indent = {
        char = "│",      -- 使用制表符样式的竖线
        highlight = {     -- 使用渐变色的缩进线
          "GlowIndent1", -- 第一级缩进颜色
          "GlowIndent2", -- 第二级缩进颜色
        },
      },
      scope = {          -- 代码块范围显示
        enabled = true,
        char = "│",      -- 范围指示线样式
        show_start = false,  -- 不显示开始标记
        show_end = false,    -- 不显示结束标记
        highlight = "GlowScope", -- 范围指示线的高亮组
      },
    },
    config = function(_, opts)
      -- 渐变色配置
      local colors = {
        "#7aa2f7",  -- 蓝色：用于浅层缩进
        "#bb9af7",  -- 紫色：用于深层缩进
      }
      
      -- 设置缩进线的高亮颜色
      for i, color in ipairs(colors) do
        vim.api.nvim_set_hl(0, "GlowIndent" .. i, {
          fg = color,           -- 前景色
          nocombine = true,     -- 防止与其他高亮冲突
        })
      end
      
      -- 设置代码块范围线的高亮
      vim.api.nvim_set_hl(0, "GlowScope", {
        fg = "#7dcfff",    -- 使用亮蓝色突出显示
        bold = true,       -- 加粗显示
        nocombine = true,  -- 防止与其他高亮冲突
      })
      
      require("ibl").setup(opts)
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

  -- Paint.nvim：代码语法荧光笔效果
  {
    "folke/paint.nvim",
    enabled = true,
    event = "BufReadPost",  -- 在缓冲区加载后启用
    config = function()
      -- 定义语法元素的颜色
      local colors = {
        comment = "#7dcfff",  -- 注释：清新的蓝色
        func = "#ff79c6",     -- 函数：醒目的粉色
        keyword = "#f1fa8c",  -- 关键字：柔和的黄色
        require = "#50fa7b",  -- require语句：翠绿色
      }

      -- 为每种语法元素创建高亮组
      for name, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "Glow" .. name:gsub("^%l", string.upper), {
          fg = color,          -- 设置前景色
          bold = true,         -- 加粗显示
          italic = name == "comment",  -- 注释使用斜体
          special = color,     -- 特殊效果颜色
          blend = 10          -- 轻微的混合效果
        })
      end

      -- 配置语法匹配规则
      require("paint").setup({
        highlights = {
          {
            filter = { filetype = "lua" },  -- 仅对Lua文件生效
            pattern = "%-%-.*",             -- 匹配注释
            hl = "GlowComment"
          },
          {
            filter = { filetype = "lua" },
            pattern = "function%s+[%w_]+%s*%(", -- 匹配函数定义
            hl = "GlowFunc"
          },
          {
            filter = { filetype = "lua" },
            pattern = "%f[%w]return%f[%W]",    -- 精确匹配return关键字
            hl = "GlowKeyword"
          },
          {
            filter = { filetype = "lua" },
            pattern = "%f[%w]require%f[%W]",   -- 精确匹配require语句
            hl = "GlowRequire"
          }
        }
      })
    end,
  },
}
