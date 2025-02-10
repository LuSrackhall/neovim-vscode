return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_enable_last_session = false,
      -- 自动保存
      auto_session_enabled = true,
      -- 自动恢复上次会话
      auto_restore_enabled = true,
      -- 自动保存会话
      auto_session_create_enabled = true,
      -- 保存会话前先清除搜索高亮
      pre_save_cmds = { "nohlsearch" },
      -- 保存会话时执行的命令
      save_extra_cmds = {
        "Neotree close"  -- 保存前关闭neo-tree
      },
      -- 恢复会话时执行的命令
      post_restore_cmds = {
        "Neotree show"   -- 恢复时重新打开neo-tree
      },      -- 会话文件目录
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      -- 自动保存间隔（毫秒）
      auto_save_interval = 60 * 1000, -- 每分钟
    }

    -- 添加会话保存/恢复的快捷键
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "保存会话" })
    vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "恢复会话" })
  end,
}
