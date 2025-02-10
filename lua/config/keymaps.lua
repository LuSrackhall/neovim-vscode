-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--[[---------------------------------------]]
--[[              工具函数                 ]]
--[[---------------------------------------]]
-- 定义一个辅助函数，用于检查当前是否在 VSCode 环境中运行
local function is_vscode()
  return vim.g.vscode ~= nil -- 如果 vim.g.vscode 不为 nil，则表示在 VSCode 中运行
end

--[[---------------------------------------]]
--[[            代码注释功能               ]]
--[[---------------------------------------]]
-- 删除 LazyVim 默认的 <C-/> 快捷键映射
-- 这是必要的，因为我们要重新定义这个快捷键的功能
vim.keymap.del("n", "<C-/>")

-- 设置新的 <C-/> 映射，这是一个根据环境智能切换的映射
vim.keymap.set({ "n", "v" }, "<C-/>", function()
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的注释命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      vscode.call("editor.action.commentLine")
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：使用 vim 的注释功能
    -- gcc 是 Comment.nvim 插件提供的注释命令
    vim.cmd("normal gcc")
  end
end, {
  silent = true,           -- 执行时不显示命令
  desc = "Toggle Comment", -- 为这个映射添加描述
})

-- 额外的注释功能映射
-- 这是为了处理终端环境的特殊情况
-- 在大多数终端中，按下 Ctrl+/ 实际上会发送 Ctrl+_, 这确保了在终端中也能正常工作。
vim.keymap.set({ "n", "v" }, "<C-_>", "gcc", {
  remap = true, -- 允许递归映射
})

--[[---------------------------------------]]
--[[            切换终端功能               ]]
--[[---------------------------------------]]
-- 设置终端切换快捷键
local function toggle_term()
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的终端切换命令
    --[[
    -- 由于vscode的neovim插件仅在编辑器的命令模式起作用, 会造成在终端中无法切回关闭的问题, 因此必须在vscode中进行配置而不是这里。
    local ok, vscode = pcall(require, "vscode")
    if ok then
      vscode.call("workbench.action.terminal.toggleTerminal")
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
    ]]
    -- VSCode 环境：
    -- 根据不同操作系统启动对应的终端
    local terminal_path
    if vim.fn.has("win32") == 1 then
      -- Windows 环境使用 Windows Terminal
      -- -- TIPS: vscode中使用说明, 通过<localleader>快捷键启用终端后, 可通过win自带的快捷键<Alt-Tab>来切回vscode。
      -- --(如果新建的终端是多余的, 则可利用win终端自带的快捷键关闭。包括其它操作也是一样的。)
      terminal_path = [[C:\Users\srackHall\AppData\Local\Microsoft\WindowsApps\wt.exe]]
    elseif vim.fn.has("mac") == 1 then
      -- macOS 环境使用 iTerm2 或其他终端
      terminal_path = "" -- TODO: 设置 macOS 终端路径
    elseif vim.fn.has("unix") == 1 then
      -- Linux 环境使用默认终端
      terminal_path = "" -- TODO: 设置 Linux 终端路径
    else
      -- 其他未知操作系统
      vim.notify("不支持的操作系统", vim.log.levels.WARN)
      terminal_path = ""
    end
    -- 获取当前工作目录
    local current_dir = vim.fn.getcwd()

    -- 使用 vim.fn.system 启动终端
    if terminal_path ~= "" then
      -- -d 参数指定启动目录
      vim.fn.system(string.format([[%s -d "%s"]], terminal_path, current_dir))
    else
      vim.notify("未配置终端路径", vim.log.levels.WARN)
    end
  else
    -- Neovim 环境：使用 snacks 模块
    local ok, snacks = pcall(require, "snacks")
    if ok then
      snacks.terminal()
    else
      vim.notify("无法加载 snacks 模块", vim.log.levels.WARN)
    end
  end
end

-- 尝试不同的快捷键写法
-- 考虑在不同终端中，Ctrl+` 可能会被解释为不同的按键序列, 但都没能成功。
local function map_terminal_keys()
  -- 主要的终端切换键
  local keys = {
    -- "<C-`>",      -- 标准写法
    -- "\x1E",       -- 某些终端中 Ctrl+` 会发送这个键码
    -- "<C-~>",      -- Windows Terminal 可能的解释
    -- "<C-]>",      -- 另一种可能的解释
    -- "<C-Space>",  -- 通用替代方案
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- --
    -- 本地leader键方案(新主力键)
    "<localleader>t", -- 本地leader键方案(新主力键)
    "<F7>",           -- 功能键替代方案
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- --
  }

  -- 遍历所有键并设置映射
  for _, key in ipairs(keys) do
    -- 设置映射
    vim.keymap.set({ "n", "t" }, key, toggle_term, {
      -- 添加描述, 会在输入过程中在右下角显示。
      desc = "切换终端 (" .. key .. ")",
      -- 执行时不显示命令
      silent = true,
    })
  end
end

map_terminal_keys()

-- 确保终端在打开时进入插入模式
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
  end,
})

--[[--------------------------------------------]]
-- Enable VSCode's built-in search functionality in normal, visual, and insert modes
vim.keymap.set({ "n", "v", "i" }, "<C-f>", function()
  if is_vscode() then
    local ok, vscode = pcall(require, "vscode")
    if ok then
      vscode.call("actions.find")
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 在neovim中, 采用默认行为。
    -- vim.cmd("normal /")
  end
end, {
  silent = true,
  desc = "VSCode Search",
})

--[[             撤销重做功能                   ]]
--[[--------------------------------------------]]
-- FIXME: VSCode中莫名奇妙符合了需求, 但配置内容实际上不一定正确, 且NeoVim端存在bug。(但由于我个人对于NeoVim用的少, 因此只要vscode能用不出bug, 就可以了。 如果一直没问题, 那么这个Fix将被永远挂起。))
--        * bug内容是, <C-z> 和 <C-S-z> 无法正常工作, 但u和U可以正常工作。
-- TIPS: 可以明确的一点是, 在NeoVim中配置两组独立的撤销重做快捷键是不可能的。 (因为撤销和重做操作都会影响同一个全局的撤销树)
--       * 在 Neovim（以及 Vim）的设计中，撤销和重做操作都会影响同一个全局的撤销树，所以无法配置出两套独立的撤销历史。不过真想实现的话, 可以寻找类似功能的插件来适配。
-- - -- ---------------------------------------- --  - --
-- --[[  提供撤销和重做功能:                      ]] -- --
-- --[[  * Ctrl+z     - 撤销                      ]] -- --
-- --[[  * Ctrl+S+z   - 重做                      ]] -- --
-- --[[  * u          - 撤销(vim原生)             ]] -- --
-- --[[  * U          - 重做(vim原生)             ]] -- --
-- - -- ---------------------------------------- --  - --

-- 撤销重做函数
local function undo_redo_action(action)
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的撤销重做命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      if action == "undo" then
        vscode.call("undo")
      elseif action == "redo" then
        vscode.call("redo")
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- Neovim 环境：使用vim的撤销重做命令
    if action == "undo" then
      vim.cmd("undo")
    elseif action == "redo" then
      vim.cmd("redo")
    end
  end
end

-- 设置撤销重做快捷键
local undo_redo_mappings = {
  -- Ctrl系列快捷键 (VSCode风格)
  ["<C-z>"] = {
    mode = { "n", "i" },
    action = "undo",
    desc = "撤销"
  },
  ["<C-S-z>"] = {
    mode = { "n", "i" },
    action = "redo",
    desc = "重做"
  },
}

-- 应用Ctrl系列映射
for key, mapping in pairs(undo_redo_mappings) do
  vim.keymap.set(mapping.mode, key, function()
    undo_redo_action(mapping.action)
  end, {
    silent = true,
    desc = mapping.desc
  })
end

-- 设置vim原生的u/U映射
-- 注意：这些映射使用vim的内置撤销系统，与Ctrl系列独立
vim.keymap.set("n", "u", "u", {
  silent = true,
  desc = "Vim式撤销"
})
vim.keymap.set("n", "U", "<C-r>", {
  silent = true,
  desc = "Vim式重做"
})

--[[---------------------------------------]]
--[[            剪贴板功能                 ]]
--[[---------------------------------------]]
-- 定义剪贴板操作函数
local function clipboard_operation(operation)
  if is_vscode() then
    -- VSCode 环境：使用 VSCode 的剪贴板命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      -- 什么都不用做, 交给vscode的默认行为处理即可(前提是禁用neovim插件中对 'ctrl+c' 的默认行为, 比如更改其键绑定为`ctrl+number8 ctrl+number8`, 有几个改几个, 都改成相同的按键即可。)
      if operation == "copy" then
        -- TIPS: 在这里处理, 是因为在vscode中:
        --       ```json
        --       // keybindings.json
        --       {
        --         // TIPS: 需要注意的是, 对于ctrl+c来说, 似乎绑定一个命令后, 就无法绑定其它命令了(主要是我所需要的 复制 和 esc 功能在这里似乎冲突了)
        --         //       > TIPS: 比如我在这里定义的传递功能, 也影响到了vscode的系统复制api 以及neovim自带的 esc  api的触发。
        --         "key": "ctrl+c",
        --         "command": "vscode-neovim.send",
        --         "when": "editorTextFocus && neovim.mode != 'normal'",
        --         // Send this input to Neovim.
        --         "args": "<C-c>"
        --       }
        --       ```
        --       上述代码块中的内容, 需原样粘贴到vscode的配置中, 方可使得当前判断中的内容生效。(否则不生效)
        vscode.call("editor.action.clipboardCopyAction")
        vscode.call("vscode-neovim.escape")
        -- 向vscode-neovim插件发送调试信息
        vim.notify("执行vscode复制操作", vim.log.levels.DEBUG)
        -- 剪切操作已注释，因为使用频率极低(且VSCodeVim这个插件也没有配置这个快捷键)(最重要的是在V模式下使用此api时, 有机率发生整行都被剪切掉的现象, 无法保证一直都是仅剪切选中内容。)
        -- elseif operation == "cut" then
        -- vscode.call("editor.action.clipboardCutAction")
        -- -- 向vscode-neovim插件发送调试信息
        -- vim.notify("执行vscode剪切操作", vim.log.levels.DEBUG)
      elseif operation == "paste" then
        vscode.call("editor.action.clipboardPasteAction")
        -- 向vscode-neovim插件发送调试信息
        vim.notify("执行vscode粘贴操作", vim.log.levels.DEBUG)
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- Neovim 环境：使用系统剪贴板，但保持与 vim 寄存器独立
    if operation == "copy" then
      -- 仅复制到系统剪贴板，不影响 vim 寄存器
      local old_reg = vim.fn.getreg('"') -- 保存当前寄存器内容
      vim.cmd('normal! "+y')             -- 复制到系统剪贴板
      vim.fn.setreg('"', old_reg)        -- 恢复寄存器内容
    elseif operation == "paste" then
      -- 仅从系统剪贴板粘贴，不影响 vim 寄存器
      vim.cmd('normal! "+p')
    end
  end
end

-- 设置剪贴板快捷键
local clipboard_mappings = {
  -- 复制 (实际上直接交由vscode处理就好了, 只需要在vscode中禁用掉neovim插件自带的为vscode按键映射界面绑定的快捷键'ctrl+c'就可以了)
  ["<C-c>"] = { -- 保留在此是因为neovim中的行为也是需要处理的
    mode = { "v" },
    action = function()
      clipboard_operation("copy")
    end,
    desc = "复制到系统剪贴板",
  },

  -- 剪切 (默认注释掉，因为这个功能使用频率极低)(且VSCodeVim这个插件也没有配置这个快捷键)(最重要的是在V模式下使用此api时, 有机率发生整行都被剪切掉的现象, 无法保证一直都是仅剪切选中内容。)
  -- ["<C-x>"] = {
  -- mode = {"v"},
  -- action = function() clipboard_operation("cut") end,
  -- desc = "剪切到系统剪贴板"
  -- },

  -- 粘贴
  ["<C-v>"] = {
    -- mode = {"n", "i"}, -- 实际上 i 模式下, 也是使用vscode的默认行为就好了, 注主要起作用的是n模式下的配置。不过为了安全起见这里我们也没必要配置了。
    mode = { "i" }, -- 保留是因为在neovim中我还需要使用
    action = function()
      clipboard_operation("paste")
    end,
    desc = "从系统剪贴板粘贴",
  },
}

-- 应用映射(不用改动)
for key, mapping in pairs(clipboard_mappings) do
  vim.keymap.set(mapping.mode, key, mapping.action, {
    silent = true,
    desc = mapping.desc,
  })
end

--[[---------------------------------------]]
--[[        为vscode映射<leader>键         ]]
--[[---------------------------------------]]
-- VSCode 功能键映射
local function setup_vscode_keymaps()
  if not is_vscode() then
    return
  end

  local ok, vscode = pcall(require, "vscode")
  if not ok then
    vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    return
  end

  -- 文件资源管理器(无法实现, 因此改为切换侧边栏)
  -- vim.keymap.set("n", "<leader>e", function()
  --   -- 如果侧边栏已经打开并且聚焦，则关闭(其中vim.g.vscode_sidebar_focused 这个变量实际上并不存在, 写在这里只是方便阅读)
  --   if vim.g.vscode_sidebar_focused then
  --     vscode.call("workbench.action.toggleSidebarVisibility")
  --   else
  --     -- 否则打开并聚焦到资源管理器
  --     vscode.call("workbench.view.explorer")
  --   end
  -- end, { desc = "切换文件资源管理器" })

  -- 切换侧边栏
  vim.keymap.set("n", "<leader>e", function()
    vscode.call("workbench.action.toggleSidebarVisibility")
  end, { desc = "切换文件资源管理器" })

  -- 搜索文件
  vim.keymap.set("n", "<leader> <leader>", function()
    vscode.call("workbench.action.quickOpen")
  end, { desc = "搜索文件" })

  -- 搜索文件
  vim.keymap.set("n", "<leader>ff", function()
    vscode.call("workbench.action.quickOpen")
  end, { desc = "搜索文件" })

  -- 全局搜索
  vim.keymap.set("n", "<leader>fg", function()
    vscode.call("workbench.action.findInFiles")
  end, { desc = "全局搜索" })

  -- 切换问题面板
  vim.keymap.set("n", "<leader>xp", function()
    vscode.call("workbench.actions.view.problems")
  end, { desc = "切换问题面板" })

  -- 切换源代码管理(在vscode中, 使用lazygit来切换源代码管理)
  vim.keymap.set("n", "<leader>gg", function()
    -- 获取当前工作目录
    local current_dir = vim.fn.getcwd()

    -- 根据操作系统选择适当的终端和命令
    if vim.fn.has("win32") == 1 then
      -- Windows 环境使用 Windows Terminal
      local terminal_path = [[C:\Users\srackHall\AppData\Local\Microsoft\WindowsApps\wt.exe]]
      -- 启动终端并运行 lazygit(通过-p参数指定wt使用 Git Bash, 需要注意的是-p后根的是wt中为某个shell配置的名称--这个名称取决与用户在终端中的自定义配置(比如我的是"Bash"))
      vim.fn.system(string.format([[%s --pos 160,90 --fullscreen --window new -p "Bash" -d "%s" lazygit]], terminal_path,
        current_dir))
      -- 1. `--fullscreen`：全屏模式启动，隐藏标题栏和边框
      -- 2. `--maximized`/`-M`：最大化窗口启动
      -- 3.  `--window new`: 在新的窗口中启动标签页。
      -- 4. `-p "Bash"`: 指定使用要使用的配置文件名称。(即wt中对于shell的配置名称, 这里我尝试了, 不管使用哪个shell, 都存在使用退出时延迟一段时间后才关闭的情况)
      -- 5. `focus`, `-f`：启动终端时进入焦点模式。
      -- 6. `pos x,y`：启动终端时指定窗口位置，x 和 y 可选，可以使用默认值。
      -- 7. `size c,r`：启动终端时指定列数（c）和行数（r）。
      -- 8. `startingDirectory`, `-d`：指定启动目录。
      -- 9. `title`：指定新标签的标题。

      -- 延时3秒后打开gitGraph插件的log面板
      vim.defer_fn(function()
        vscode.call("git-graph.view")
      end, 3000) -- 3000毫秒 = 3秒
    elseif vim.fn.has("mac") == 1 then
      -- macOS 环境
      -- TODO: 设置 macOS 终端路径和命令
      vim.notify("macOS 环境暂未配置", vim.log.levels.WARN)
    elseif vim.fn.has("unix") == 1 then
      -- Linux 环境
      -- TODO: 设置 Linux 终端路径和命令
      vim.notify("Linux 环境暂未配置", vim.log.levels.WARN)
    else
      vim.notify("不支持的操作系统", vim.log.levels.WARN)
    end
  end, { desc = "启动 lazygit" })

  -- 代码操作建议
  vim.keymap.set("n", "<leader>ca", function()
    vscode.call("editor.action.quickFix")
  end, { desc = "代码操作建议" })
end

-- 调用设置函数
setup_vscode_keymaps()

--[[---------------------------------------]]
--[[   为neo适配类vscode快捷键文件浏览器    ]]
--[[---------------------------------------]]
-- 将 <C-b> 映射为 <leader>e
vim.keymap.set("n", "<C-b>", "<leader>e", {
  remap = true,
  desc = "切换文件浏览器",
})


--[[--------------------------------------------]]
--[[                标签页跳转                  ]]
--[[--------------------------------------------]]
-- - -- ---------------------------------------- --  - --
-- --[[  提供标签页快捷切换功能:                  ]] -- --
-- --[[  * tg  - 跳转到上一个标签页（自定义按键） ]] -- --
-- --[[  * H   - 跳转到上一个标签页（vim原生按键）]] -- --
-- --[[  * gT  - 跳转到上一个标签页（vim原生按键）]] -- --
-- --[[  /////////////////////////////////////// ]] -- --
-- --[[  * gt  - 跳转到下一个标签页（vim原生按键）]] -- --
-- --[[  * L   - 跳转到下一个标签页（vim原生按键）]] -- --
-- - -- ---------------------------------------- --  - --

-- -- 删除 LazyVim 默认的 快捷键映射 (如果有必要的话), 比如:
-- -- * p1-< 你要使用的快捷键在LazyVim中已经被其它功能占用了>
-- -- * p2-< 你要使用的功能在LazyVim中有其它的快捷键映射, 但你不需要>
-- vim.keymap.del("n", "tg")  -- 满足 p1 条件
-- vim.keymap.del("n", "H")   -- 满足 p2 条件

-- 标签跳转函数(上一页)
function jump_to_previous_tab()
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的标签切换命令
  -- * Neovim环境  - 使用BufferLine的标签切换命令
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的标签页切换命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      -- [官方文档中提到的这些, 也可以用](https://github.com/vscode-neovim/vscode-neovim?text=%2C%20etc.-,Tab%20management,%2C%20etc.,-Buffer/window%20management#:~:text=%2C%20etc.-,Tab%20management,%2C%20etc.,-Buffer/window%20management
      -- 我这里遵循的是: vscode的配置, 只要vscode本身有提供就优先使用的原则。
      -- vscode.call("workbench.action.previousEditor")
      vscode.call("workbench.action.previousEditorInGroup")
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：使用标签页切换命令
    vim.cmd("BufferLineCyclePrev")
  end
end

-- --  使用 'tg' 键跳转到上一个标签页
vim.keymap.set({ "n", "v" }, "tg", jump_to_previous_tab, {
  silent = true, -- 执行时不显示命令
  desc = "跳转到上一个标签页" -- 为这个映射添加描述
})
-- --  使用 'H' 键跳转到上一个标签页（vim原生按键）
vim.keymap.set({ "n", "v" }, "H", jump_to_previous_tab, {
  silent = true, -- 执行时不显示命令
  desc = "跳转到上一个标签页" -- 为这个映射添加描述
})
-- --  使用 'gT' 键跳转到上一个标签页（vim原生按键）
vim.keymap.set({ "n", "v" }, "gT", jump_to_previous_tab, {
  silent = true, -- 执行时不显示命令
  desc = "跳转到上一个标签页" -- 为这个映射添加描述
})

-- 标签跳转函数(下一页)
function jump_to_next_tab()
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的标签切换命令
  -- * Neovim环境  - 使用BufferLine的标签切换命令
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的标签页切换命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      -- vscode.call("workbench.action.nextEditor")
      vscode.call("workbench.action.nextEditorInGroup")
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：使用标签页切换命令
    vim.cmd("BufferLineCycleNext")
  end
end

-- --  使用 'gt' 键跳转到下一个标签页（vim原生按键）
vim.keymap.set({ "n", "v" }, "gt", jump_to_next_tab, {
  silent = true, -- 执行时不显示命令
  desc = "跳转到下一个标签页" -- 为这个映射添加描述
})
-- --  使用 'L' 键跳转到下一个标签页（vim原生按键）
vim.keymap.set({ "n", "v" }, "L", jump_to_next_tab, {
  silent = true, -- 执行时不显示命令
  desc = "跳转到下一个标签页" -- 为这个映射添加描述
})

--[[--------------------------------------------]]
--[[             Neovim待办事项                 ]]
--[[--------------------------------------------]]
-- - -- ------------------------------------------- -- - --
-- --[[  TIPS: 接下来的工作将集中在适配VSCode,       ]] -- --
-- --[[        至于Neovim仅作为待办项存放于此       ]] -- --
-- --[[        按照惯例为NeoVim预留配置空位         ]] -- --
-- --[[  ///////////////////////////////////////// ]] -- --
-- --[[  TODO:                                      ]] -- --
-- --[[  * 为NeoVim配置 <C-s> 来保存当前文件        ]] -- --
-- --[[  * 为NeoVim配置 <C-w-w> 来关闭当前标签页    ]] -- --
-- --[[  * 为NeoVim配置 <C-0> 跳转到资源管理器或Git ]] -- --
-- --[[  * 为NeoVim预留配置空间                     ]] -- --
-- --[[  * 为NeoVim预留配置空间                     ]] -- --
-- --[[  * 为NeoVim预留配置空间                     ]] -- --
-- - -- ------------------------------------------- -- - --

--[[--------------------------------------------]]
--[[             移动标签页功能                 ]]
--[[--------------------------------------------]]
-- - -- ---------------------------------------- --  - --
-- --[[  提供标签页移动功能:                      ]] -- --
-- --[[  以下提供两组快捷键方案:                  ]] -- --
-- --[[  1. 传统组合键方案:                       ]] -- --
-- --[[     * g;  - 移动标签页到右侧窗口         ]] -- --
-- --[[     * ;g  - 移动标签页到左侧窗口         ]] -- --
-- --[[     * t;  - 移动标签页到下侧窗口         ]] -- --
-- --[[     * ;t  - 移动标签页到上侧窗口         ]] -- --
-- --[[  2. Leader键方案(更直观):                 ]] -- --
-- --[[     * <leader>gl - 移动标签页到右侧窗口  ]] -- --
-- --[[     * <leader>gh - 移动标签页到左侧窗口  ]] -- --
-- --[[     * <leader>gj - 移动标签页到下侧窗口  ]] -- --
-- --[[     * <leader>gk - 移动标签页到上侧窗口  ]] -- --
-- - -- ---------------------------------------- --  - --
-- - -- ---------------------------------------- --  - --

-- 移动标签页到不同窗口的函数
function move_editor_to_group(direction)
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的窗口移动命令
  -- * Neovim环境  - 暂时不支持
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的窗口移动命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      if direction == "next" then
        vscode.call("workbench.action.moveEditorToNextGroup")
      elseif direction == "previous" then
        vscode.call("workbench.action.moveEditorToPreviousGroup")
      elseif direction == "below" then
        vscode.call("workbench.action.moveEditorToBelowGroup")
      elseif direction == "above" then
        vscode.call("workbench.action.moveEditorToAboveGroup")
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：暂不支持
    vim.notify("Neovim 环境暂不支持此功能", vim.log.levels.WARN)
  end
end

-- 设置标签页移动快捷键
vim.keymap.set("n", "g;", function() move_editor_to_group("next") end, {
  silent = true,
  desc = "移动标签页到右侧窗口"
})
vim.keymap.set("n", ";g", function() move_editor_to_group("previous") end, {
  silent = true,
  desc = "移动标签页到左侧窗口"
})
vim.keymap.set("n", "t;", function() move_editor_to_group("below") end, {
  silent = true,
  desc = "移动标签页到下侧窗口"
})
vim.keymap.set("n", ";t", function() move_editor_to_group("above") end, {
  silent = true,
  desc = "移动标签页到上侧窗口"
})

-- 新增 <leader> 组合键的标签页移动快捷键
vim.keymap.set("n", "<leader>gl", function() move_editor_to_group("next") end, {
  silent = true,
  desc = "移动标签页到右侧窗口"
})
vim.keymap.set("n", "<leader>gh", function() move_editor_to_group("previous") end, {
  silent = true,
  desc = "移动标签页到左侧窗口"
})
vim.keymap.set("n", "<leader>gj", function() move_editor_to_group("below") end, {
  silent = true,
  desc = "移动标签页到下侧窗口"
})
vim.keymap.set("n", "<leader>gk", function() move_editor_to_group("above") end, {
  silent = true,
  desc = "移动标签页到上侧窗口"
})

--[[--------------------------------------------]]
--[[             光标跳转功能                   ]]
--[[--------------------------------------------]]
-- - -- ---------------------------------------- --  - --
-- --[[  提供光标在窗口间移动功能:                ]] -- --
-- --[[  * gy  - 移动光标到右侧窗口              ]] -- --
-- --[[  * yg  - 移动光标到左侧窗口              ]] -- --
-- --[[  * ty  - 移动光标到下侧窗口              ]] -- --
-- --[[  * yt  - 移动光标到上侧窗口              ]] -- --
-- --[[  /////////////////////////////////////// ]] -- --
-- --[[  * <leader>wl - 移动光标到右侧窗口       ]] -- --
-- --[[  * <leader>wh - 移动光标到左侧窗口       ]] -- --
-- --[[  * <leader>wj - 移动光标到下侧窗口       ]] -- --
-- --[[  * <leader>wk - 移动光标到上侧窗口       ]] -- --
-- - -- ---------------------------------------- --  - --

-- 移动光标到不同窗口的函数
function focus_group(direction)
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的窗口聚焦命令
  -- * Neovim环境  - 暂时不支持
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的窗口聚焦命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      if direction == "right" then
        vscode.call("workbench.action.focusRightGroup")
      elseif direction == "left" then
        vscode.call("workbench.action.focusLeftGroup")
      elseif direction == "below" then
        vscode.call("workbench.action.focusBelowGroup")
      elseif direction == "above" then
        vscode.call("workbench.action.focusAboveGroup")
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：暂不支持
    vim.notify("Neovim 环境暂不支持此功能", vim.log.levels.WARN)
  end
end

-- 设置光标移动快捷键
vim.keymap.set("n", "gy", function() focus_group("right") end, {
  silent = true,
  desc = "移动光标到右侧窗口"
})
vim.keymap.set("n", "yg", function() focus_group("left") end, {
  silent = true,
  desc = "移动光标到左侧窗口"
})
vim.keymap.set("n", "ty", function() focus_group("below") end, {
  silent = true,
  desc = "移动光标到下侧窗口"
})
vim.keymap.set("n", "yt", function() focus_group("above") end, {
  silent = true,
  desc = "移动光标到上侧窗口"
})

-- 新增 <leader>w 组合键的光标移动快捷键
vim.keymap.set("n", "<leader>wl", function() focus_group("right") end, {
  silent = true,
  desc = "移动光标到右侧窗口"
})
vim.keymap.set("n", "<leader>wh", function() focus_group("left") end, {
  silent = true,
  desc = "移动光标到左侧窗口"
})
vim.keymap.set("n", "<leader>wj", function() focus_group("below") end, {
  silent = true,
  desc = "移动光标到下侧窗口"
})
vim.keymap.set("n", "<leader>wk", function() focus_group("above") end, {
  silent = true,
  desc = "移动光标到上侧窗口"
})

--[[--------------------------------------------]]
--[[             代码功能增强                   ]]
--[[--------------------------------------------]]
-- - -- ---------------------------------------- --  - --
-- --[[  提供代码功能增强:                        ]] -- --
-- --[[  * ge - 跳转到下一个问题                  ]] -- --
-- --[[  * gl - 切换代码折叠                      ]] -- --
-- --[[  * gh - 显示定义预览                      ]] -- --
-- --[[  * mgn - 查看下一个代码差异               ]] -- --    --FIXME: 无法聚焦到对应窗口
-- --[[  * mgp - 查看上一个代码差异               ]] -- --    --FIXME: 无法聚焦到对应窗口
-- --[[  * mgm - 打开上下文菜单                   ]] -- --    --FIXME: 无法聚焦到对应窗口
-- - -- ---------------------------------------- --  - --

-- 代码增强函数
function code_action(action)
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的代码功能命令
  -- * Neovim环境  - 暂时不支持
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的代码功能命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      if action == "next_problem" then
        vscode.call("editor.action.marker.next")
      elseif action == "toggle_fold" then
        vscode.call("editor.toggleFold")
      elseif action == "show_hover" then
        vscode.call("editor.action.showDefinitionPreviewHover")
      elseif action == "next_change" then
        vscode.call("editor.action.dirtydiff.next")
      elseif action == "prev_change" then
        vscode.call("editor.action.dirtydiff.previous")
      elseif action == "context_menu" then
        vscode.call("editor.action.showContextMenu")
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：暂不支持
    vim.notify("Neovim 环境暂不支持此功能", vim.log.levels.WARN)
  end
end

-- 设置代码功能快捷键
local code_mappings = {
  -- 普通模式下的映射
  normal = {
    -- 跳转到下一个问题
    ["ge"] = { action = "next_problem", desc = "跳转到下一个问题" },
    -- 切换代码折叠
    ["gl"] = { action = "toggle_fold", desc = "切换代码折叠" },
    -- 显示定义预览
    ["gh"] = { action = "show_hover", desc = "显示定义预览" },
    -- 查看下一个代码差异
    ["mgn"] = { action = "next_change", desc = "查看下一个代码差异" },
    -- 查看上一个代码差异
    ["mgp"] = { action = "prev_change", desc = "查看上一个代码差异" },
    -- 打开上下文菜单
    ["mgm"] = { action = "context_menu", desc = "打开上下文菜单" }
  },
  -- 可视模式下的映射
  visual = {
    -- 显示定义预览
    ["gh"] = { action = "show_hover", desc = "显示定义预览" },
    -- 打开上下文菜单
    ["mgm"] = { action = "context_menu", desc = "打开上下文菜单" }
  }
}

-- 应用映射
for mode, mappings in pairs(code_mappings) do
  for key, mapping in pairs(mappings) do
    vim.keymap.set(mode == "normal" and "n" or "v", key, function()
      code_action(mapping.action)
    end, {
      silent = true,
      desc = mapping.desc
    })
  end
end

--[[--------------------------------------------]]
--[[             Git 功能增强                   ]]
--[[--------------------------------------------]]
-- - -- ---------------------------------------- --  - --
-- --[[  提供可视模式下的 Git 功能:               ]] -- --
-- --[[  * mgs - 暂存所选范围                     ]] -- --
-- --[[  * mgc - 取消暂存所选范围                 ]] -- --
-- --[[  * mgd - 还原所选范围变更                 ]] -- --
-- - -- ---------------------------------------- --  - --

-- Git 操作函数
function git_action(action)
  -- 环境智能适配:
  -- * VSCode环境  - 使用VSCode的Git命令
  -- * Neovim环境  - 暂时不支持
  if is_vscode() then
    -- VSCode 环境：调用 VSCode 的Git命令
    local ok, vscode = pcall(require, "vscode")
    if ok then
      if action == "stage" then
        vscode.call("git.stageSelectedRanges")
      elseif action == "unstage" then
        vscode.call("git.unstageSelectedRanges")
      elseif action == "revert" then
        vscode.call("git.revertSelectedRanges")
      end
    else
      vim.notify("VSCode 模块加载失败", vim.log.levels.WARN)
    end
  else
    -- 纯 Neovim 环境：暂不支持
    vim.notify("Neovim 环境暂不支持此功能", vim.log.levels.WARN)
  end
end

-- 设置可视模式下的Git快捷键
vim.keymap.set("v", "mgs", function() git_action("stage") end, {
  silent = true,
  desc = "暂存所选范围"
})
vim.keymap.set("v", "mgc", function() git_action("unstage") end, {
  silent = true,
  desc = "取消暂存所选范围"
})
vim.keymap.set("v", "mgd", function() git_action("revert") end, {
  silent = true,
  desc = "还原所选范围变更"
})
