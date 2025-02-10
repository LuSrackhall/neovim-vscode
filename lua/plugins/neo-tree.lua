return {
  "nvim-neo-tree/neo-tree.nvim",
  -- 对于<C-b>的配置, 我们直接交由keymaps.lua文件, 在其中将其映射到<leader>e
  -- 但仍需配置在目录中时, 用于关闭目录的命令。(否则在neovim中, 会发生使用<C-b>不会关闭目录窗口的bug)
  opts = {
    enable = true,
    window = {
      mappings = {
        ["<C-b>"] = "close_window",
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      -- Session支持
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_by_name = {
          ".git",
          "node_modules",
        },
      },
    },
  },
  config = function(_, opts)
    -- 确保neo-tree配置在session之前完成初始化
    require("neo-tree").setup(vim.tbl_deep_extend("force", {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      source_selector = {
        winbar = true,
        content_layout = "center",
      },
      -- Session持久化配置
      use_session_persistence = true,
      -- 状态文件位置（使用完整路径）
      state_file_path = vim.fn.stdpath("state") .. "/neo-tree.state",
    }, opts))
  end,
  -- 对于想把 默认 P键 的实时预览文件功能, 改为默认行为的想法, 劝你立刻打消, 因为vscode中也不是这种行为。最关键是这种行为有个弊端--我们在浏览目录时偶尔会希望文件窗口保持固定。 因此P键的保留很重要。
}
