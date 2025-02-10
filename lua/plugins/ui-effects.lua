return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
      
      -- Neovide配置
      if vim.g.neovide then
        -- 字体设置
        vim.o.guifont = "DepartureMono Nerd Font Mono"
        
        -- 光标设置
        vim.g.neovide_cursor_animation_length = 0.08  -- 光标动画长度，较短的值使移动更快
        vim.g.neovide_cursor_trail_length = 0.8      -- 增加拖尾长度，使效果更明显
        vim.g.neovide_cursor_vfx_mode = "railgun"    -- 使用railgun特效，比sonicboom更炫酷
        vim.g.neovide_cursor_vfx_opacity = 0.9       -- 增加不透明度
        vim.g.neovide_cursor_vfx_particle_density = 12.0  -- 增加粒子密度
        vim.g.neovide_cursor_vfx_particle_speed = 12.0    -- 增加粒子速度
        vim.g.neovide_cursor_animate_in_insert_mode = true
        vim.g.neovide_cursor_animate_command_line = true
        
        -- 窗口设置
        vim.g.neovide_transparency = 0.93            -- 稍微提高透明度
        vim.g.neovide_floating_blur_amount_x = 2.5   -- 增加模糊效果
        vim.g.neovide_floating_blur_amount_y = 2.5
        
        -- 动画设置
        vim.g.neovide_scroll_animation_length = 0.4  -- 稍微增加滚动动画长度
        vim.g.neovide_refresh_rate = 75             -- 提高刷新率，使动画更流畅
        vim.g.neovide_no_idle = true
        vim.g.neovide_remember_window_size = true
        vim.g.neovide_profiler = false              -- 禁用性能分析以提高性能
      end
    end,
  },
  {
    "folke/paint.nvim",
    enabled = true,
    event = "BufReadPost",
    config = function()
      local colors = {
        comment = "#7dcfff",
        func = "#ff79c6",
        keyword = "#f1fa8c",
        require = "#50fa7b",
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

      require("paint").setup({
        highlights = {
          {
            filter = { filetype = "lua" },
            pattern = "%-%-.*",
            hl = "GlowComment"
          },
          {
            filter = { filetype = "lua" },
            pattern = "function%s+[%w_]+%s*%(", 
            hl = "GlowFunc"
          },
          {
            filter = { filetype = "lua" },
            pattern = "%f[%w]return%f[%W]",
            hl = "GlowKeyword"
          },
          {
            filter = { filetype = "lua" },
            pattern = "%f[%w]require%f[%W]",
            hl = "GlowRequire"
          }
        }
      })
    end,
  },
}
