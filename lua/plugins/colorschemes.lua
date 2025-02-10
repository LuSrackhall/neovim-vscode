return {
  -- Catppuccin 主题
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
      -- 设置为默认主题
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Neon 主题
  {
    dir = vim.fn.stdpath("config") .. "/lua/colors",
    name = "neon",
    priority = 1000,
    config = function()
      -- 创建颜色方案命令
      vim.api.nvim_create_user_command("NeonColors", function()
        vim.cmd("runtime colors/neon.lua")
      end, {})

      -- 将主题注册到 colorscheme 命令
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "neon",
        callback = function()
          require("colors.neon").setup()
        end,
      })
    end,
  }
}