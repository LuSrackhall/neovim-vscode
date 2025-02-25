-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
end

if vim.g.neovide then
  vim.keymap.set("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { silent = true })
end

