return {
  -- UI组件增强
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        indicator = {
          icon = '▎', -- 缓冲区指示器
          style = 'icon',
        },
        separator_style = "slope",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
      highlights = {
        -- 增强bufferline高亮效果
        fill = { bg = "#1a1b26" },
        background = { bg = "#1a1b26" },
        tab = { bg = "#1a1b26" },
        tab_selected = { 
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
        buffer_visible = { bg = "#1a1b26" },
        buffer_selected = {
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
        diagnostic = { bg = "#1a1b26" },
        diagnostic_selected = { 
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
        hint = { bg = "#1a1b26" },
        hint_selected = {
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
        warning = { bg = "#1a1b26" },
        warning_selected = {
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
        error = { bg = "#1a1b26" },
        error_selected = {
          bg = "#7aa2f7",
          fg = "#1a1b26",
          bold = true,
          italic = true,
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = { "filename", "branch" },
        lualine_c = { "fileformat" },
        lualine_x = {},
        lualine_y = { "filetype", "progress" },
        lualine_z = {
          { "location", separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        highlight = {
          "GlowIndent1",
          "GlowIndent2",
        },
      },
      scope = { 
        enabled = true,
        char = "│",
        show_start = false,
        show_end = false,
        highlight = "GlowScope",
      },
    },
    config = function(_, opts)
      -- 设置渐变色的缩进线
      local colors = {
        "#7aa2f7",  -- 蓝色
        "#bb9af7",  -- 紫色
      }
      
      -- 设置缩进线高亮组
      for i, color in ipairs(colors) do
        vim.api.nvim_set_hl(0, "GlowIndent" .. i, {
          fg = color,
          nocombine = true,
        })
      end
      
      -- 设置作用域高亮
      vim.api.nvim_set_hl(0, "GlowScope", {
        fg = "#7dcfff",
        bold = true,
        nocombine = true,
      })
      
      require("ibl").setup(opts)
    end,
  },

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
  
  -- Neovide GUI配置
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
    config = function()
      -- 检查是否在Neovide环境中
      if vim.g.neovide then
        -- 设置Neovide特定选项
        vim.o.guifont = "FiraCode Nerd Font:h14" -- 使用 Nerd Font
        
        -- 光标设置
        vim.g.neovide_cursor_animation_length = 0.1 -- 光标动画长度
        vim.g.neovide_cursor_trail_length = 0.5 -- 光标拖尾长度
        vim.g.neovide_cursor_vfx_mode = "sonicboom" -- 光标特效模式
        vim.g.neovide_cursor_vfx_opacity = 0.8 -- 特效不透明度
        vim.g.neovide_cursor_vfx_particle_density = 10.0 -- 粒子密度
        vim.g.neovide_cursor_animate_command_line = true -- 命令行光标动画
        
        -- 窗口设置
        vim.g.neovide_transparency = 0.9 -- 窗口透明度
        vim.g.neovide_floating_blur_amount_x = 2.0 -- 浮动窗口模糊
        vim.g.neovide_floating_blur_amount_y = 2.0
        
        -- 动画设置
        vim.g.neovide_scroll_animation_length = 0.3 -- 滚动动画
        vim.g.neovide_refresh_rate = 60 -- 刷新率
        vim.g.neovide_no_idle = true -- 禁用空闲以保持动画流畅
      end
    end,
  },

  -- 代码高亮增强
  {
    "folke/paint.nvim",
    enabled = true,
    event = "BufReadPost", -- 在缓冲区加载后配置高亮
    config = function()
      -- 定义颜色方案
      local colors = {
        comment = "#7dcfff",    -- 注释：亮蓝色
        func = "#ff79c6",       -- 函数：粉色
        keyword = "#f1fa8c",    -- 关键字：黄色
        require = "#50fa7b",    -- require：绿色
        string = "#e6c384",     -- 字符串：橙色
        property = "#bb9af7",   -- 属性：紫色
        operator = "#89ddff",   -- 运算符：天蓝色
        variable = "#7aa2f7"    -- 变量：蓝色
      }

      -- 定义高亮规则
      local highlights = {
        -- Lua语言规则
        lua = {
          { pattern = "%-%-.*", style = "comment" },  -- 注释
          { pattern = "function%s+[%w_]+%s*%(", style = "func" },  -- 函数定义
          { pattern = "%f[%w]return%f[%W]", style = "keyword" },  -- return关键字
          { pattern = "%f[%w]require%f[%W]", style = "require" },  -- require关键字
          { pattern = "%f[%w]local%f[%W]", style = "keyword" },  -- local关键字
          { pattern = "%f[%w]if%f[%W]", style = "keyword" },  -- if关键字
          { pattern = "%f[%w]then%f[%W]", style = "keyword" },  -- then关键字
          { pattern = "%f[%w]else%f[%W]", style = "keyword" },  -- else关键字
          { pattern = "%f[%w]elseif%f[%W]", style = "keyword" },  -- elseif关键字
          { pattern = "%f[%w]end%f[%W]", style = "keyword" },  -- end关键字
          { pattern = "%f[%w]for%f[%W]", style = "keyword" },  -- for关键字
          { pattern = "%f[%w]while%f[%W]", style = "keyword" },  -- while关键字
          { pattern = "%f[%w]do%f[%W]", style = "keyword" },  -- do关键字
          { pattern = "%f[%w]in%f[%W]", style = "keyword" },  -- in关键字
          { pattern = "[\"'].+[\"']", style = "string" },  -- 字符串
          { pattern = "[%w_]+%s*=", style = "variable" },  -- 变量赋值
          { pattern = "%.%w+", style = "property" },  -- 属性访问
          { pattern = "[%+%-%*/=~<>]", style = "operator" },  -- 运算符
        }
      }
      
      -- 设置高亮组
      for name, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "Glow" .. name:gsub("^%l", string.upper), {
          fg = color,
          bold = true,
          italic = name == "comment",
          special = color,
          blend = 10
        })
      end
      
      -- 构建paint.nvim配置
      local paint_highlights = {}
      for ft, rules in pairs(highlights) do
        for _, rule in ipairs(rules) do
          table.insert(paint_highlights, {
            filter = { filetype = ft },
            pattern = rule.pattern,
            hl = "Glow" .. rule.style:gsub("^%l", string.upper)
          })
        end
      end
      
      -- 配置paint.nvim
      require("paint").setup({
        highlights = paint_highlights
      })
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
