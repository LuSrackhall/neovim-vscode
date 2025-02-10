return {
  -- Catppuccin 主题：默认主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "bold" },
        functions = { "bold" },
        strings = { "italic" },
        variables = { "bold" },
      },
      integrations = {
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- 注册自定义主题目录
  {
    dir = vim.fn.stdpath("config") .. "/lua/themes",
    name = "custom-themes",
    priority = 1001,
    config = function()
      -- 将主题目录添加到运行时路径
      local themes_path = vim.fn.stdpath("config") .. "/lua/themes"
      vim.opt.rtp:prepend(themes_path)

      -- 注册自定义主题
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "neon",
        callback = function()
          package.loaded["themes.neon"] = nil
          dofile(themes_path .. "/neon.lua")
        end,
      })
    end,
  },
}