-- UI效果增强配置
return {
  -- mini.animate: 平滑的光标和窗口动画
  {
    'echasnovski/mini.animate',
    version = '*',
    event = "VeryLazy",
    config = function()
      local animate = require('mini.animate')
      animate.setup({
        cursor = {
          enable = true,
          timing = function(_, n) return 100 / n end,
          path = animate.gen_path.spiral(),
        },
        scroll = {
          enable = true,
          timing = function(_, n) return 150 / n end,
        },
        resize = {
          enable = true,
          timing = function(_, n) return 100 / n end,
        },
        open = {
          enable = true,
          timing = function(_, n) return 100 / n end,
        },
        close = {
          enable = true,
          timing = function(_, n) return 100 / n end,
        },
      })
    end,
  },

  -- indent-blankline：优化的缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        highlight = { "NonText" },
      },
      scope = {
        enabled = true,
        char = "│",
        show_start = false,
        show_end = false,
        highlight = "NonText",
        priority = 500,
      },
    },
  },
}
