-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--[[---------------------------------------]]
--[[              工具函数                 ]]
--[[---------------------------------------]]
-- 定义一个辅助函数，用于检查当前是否在 VSCode 环境中运行
local function is_vscode()
  return vim.g.vscode ~= nil  -- 如果 vim.g.vscode 不为 nil，则表示在 VSCode 中运行
end

--[[---------------------------------------]]
--[[            代码注释功能               ]]
--[[---------------------------------------]]
-- 删除 LazyVim 默认的 <C-/> 快捷键映射
-- 这是必要的，因为我们要重新定义这个快捷键的功能
vim.keymap.del("n", "<C-/>")

-- 设置新的 <C-/> 映射，这是一个根据环境智能切换的映射
vim.keymap.set("n", "<C-/>", function()
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
  silent = true,  -- 执行时不显示命令
  desc = "Toggle Comment"  -- 为这个映射添加描述
})

-- 额外的注释功能映射
-- 这是为了处理终端环境的特殊情况
-- 在大多数终端中，按下 Ctrl+/ 实际上会发送 Ctrl+_, 这确保了在终端中也能正常工作。
vim.keymap.set({ "n", "v" }, "<C-_>", "gcc", { 
  remap = true  -- 允许递归映射
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
    if vim.fn.has('win32') == 1 then
      -- Windows 环境使用 Windows Terminal
      -- -- TIPS: vscode中使用说明, 通过<localleader>快捷键启用终端后, 可通过win自带的快捷键<Alt-Tab>来切回vscode。
      -- --(如果新建的终端是多余的, 则可利用win终端自带的快捷键关闭。包括其它操作也是一样的。)
      terminal_path = [[C:\Users\srackHall\AppData\Local\Microsoft\WindowsApps\wt.exe]]
    elseif vim.fn.has('mac') == 1 then
      -- macOS 环境使用 iTerm2 或其他终端
      terminal_path = "" -- TODO: 设置 macOS 终端路径
    elseif vim.fn.has('unix') == 1 then
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
    "<localleader>t",-- 本地leader键方案(新主力键)
    "<F7>"           -- 功能键替代方案
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

--[[---------------------------------------]]
--[[            剪贴板功能                 ]]
--[[---------------------------------------]]
-- 定义剪贴板操作函数(TIPS: 定制的最终目的, 是为了让neovim更像VSCodeVim这个插件的行为)(vscode中, 只需要禁用插件自动给的'Ctrl+c'就可以了)
local function clipboard_operation(operation)
  if is_vscode() then
    -- VSCode 环境：使用 VSCode 的剪贴板命令
 --[[   local ok, vscode = pcall(require, "vscode")
    if ok then
      -- 什么都不用做, 交给vscode的默认行为处理即可(前提是禁用neovim插件中对 'ctrl+c' 的默认行为, 比如更改其键绑定为`ctrl+number8 ctrl+number8`, 有几个改几个, 都改成相同的按键即可。)
       if operation == "copy" then
        vscode.call("editor.action.clipboardCopyAction")
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
    end ]]
  else
    -- Neovim 环境：使用系统剪贴板
    if operation == "copy" then
      vim.cmd('normal! "+y')
    -- elseif operation == "cut" then
    --   vim.cmd('normal! "+d')
    elseif operation == "paste" then
      vim.cmd('normal! "+p')
    end
  end
end

-- 设置剪贴板快捷键
local clipboard_mappings = {
  -- 复制 (实际上直接交由vscode处理就好了, 只需要在vscode中禁用掉neovim插件自带的为vscode按键映射界面绑定的快捷键'ctrl+c'就可以了)
  ["<C-c>"] = { -- 保留在此是因为neovim中的行为也是需要处理的
    mode = {"v"},
    action = function() clipboard_operation("copy") end,
    desc = "复制到系统剪贴板"
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
    mode = {"i"}, -- 保留是因为在neovim中我还需要使用
    action = function() clipboard_operation("paste") end,
    desc = "从系统剪贴板粘贴"
  },
}

-- 应用映射(不用改动)
for key, mapping in pairs(clipboard_mappings) do
  vim.keymap.set(mapping.mode, key, mapping.action, {
    silent = true,
    desc = mapping.desc
  })
end

