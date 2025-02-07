return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- 移除默认的 <leader>e 绑定
    { "<leader>e", false },
    -- 添加 Ctrl-b 来切换侧边栏
    {
      "<C-b>",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "切换文件浏览器",
    },
  },
  opts = {
    enable = true,
    window = {
      mappings = {
        ["<C-b>"] = "close_window",
      },
    },
  },
  -- 对于想把 默认 P键 的实时预览文件功能, 改为默认行为的想法, 劝你立刻打消, 因为vscode中也不是这种行为。最关键是这种行为有个弊端--我们在浏览目录时偶尔会希望文件窗口保持固定。 因此P键的保留很重要。
}