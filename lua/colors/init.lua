local M = {}

-- 确保正确加载颜色主题
function M.init()
  -- 创建颜色文件夹
  local colors_dir = vim.fn.stdpath("config") .. "/lua/colors"
  vim.fn.mkdir(colors_dir, "p")

  -- 将颜色文件夹添加到运行时路径
  vim.opt.rtp:append(colors_dir)

  -- 设置默认主题
  vim.cmd [[
    try
      colorscheme catppuccin
    catch
      colorscheme default
    endtry
  ]]
end

return M