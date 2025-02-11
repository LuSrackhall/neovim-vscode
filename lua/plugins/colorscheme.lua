return {
  -- Catppuccin theme (default)
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
      -- Set default colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Register colors directory for custom themes
  {
    dir = vim.fn.stdpath("config"),
    name = "custom-themes",
    priority = 1001,
    config = function()
      -- Add colors directory to runtime path
      local colors_dir = vim.fn.stdpath("config") .. "/colors"
      if vim.fn.isdirectory(colors_dir) == 0 then
        vim.fn.mkdir(colors_dir, "p")
      end
      vim.opt.rtp:prepend(colors_dir)

      -- Register completion for colorscheme command
      vim.api.nvim_create_user_command("Colors", function()
        local colors = vim.fn.getcompletion("", "color")
        vim.ui.select(colors, {
          prompt = "Select colorscheme:",
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if choice then
            vim.cmd.colorscheme(choice)
          end
        end)
      end, {})
    end,
  },
}