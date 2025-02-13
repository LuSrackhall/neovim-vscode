-- ...existing code...

-- 禁止创建空白缓冲区，改为显示启动页面
do
  local function show_startpage()
    -- 尝试显示 Alpha 或 Dashboard 主页
    if vim.fn.exists(':Alpha') == 2 then
      vim.cmd('Alpha')
    elseif vim.fn.exists(':Dashboard') == 2 then
      vim.cmd('Dashboard')
    else
      -- 如果都没有，至少显示 Lazy
      pcall(vim.cmd, 'Lazy')
    end
  end

  vim.api.nvim_create_autocmd({"BufNewFile", "BufWinEnter", "BufDelete"}, {
    group = vim.api.nvim_create_augroup("NoEmptyBuffer", { clear = true }),
    callback = function(event)
      local bufname = vim.api.nvim_buf_get_name(event.buf)
      local buftype = vim.bo[event.buf].buftype
      local filetype = vim.bo[event.buf].filetype
      
      -- 处理空白缓冲区
      if bufname == "" and buftype == "" and filetype == "" then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(event.buf) then
            -- 确保不会创建新的空白缓冲区
            if #vim.fn.getbufinfo({buflisted = 1}) <= 1 then
              show_startpage()
            end
            -- 删除原空白缓冲区
            pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
          end
        end)
      end

      -- 检查是否所有标签页都被关闭
      if #vim.fn.getbufinfo({buflisted = 1}) == 0 then
        vim.schedule(show_startpage)
      end
    end,
  })
end

-- ...existing code...
