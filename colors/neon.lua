-- Simple but effective neon theme
local api = vim.api

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end

vim.g.colors_name = 'neon'
vim.o.background = 'dark'
vim.opt.termguicolors = true

-- Colors
local colors = {
    bg = "#000000",
    fg = "#FFFFFF",
    neon = {
        pink = "#FF1493",
        blue = "#00FFFF",
        green = "#39FF14",
        purple = "#9D00FF",
        yellow = "#FFFF00",
        orange = "#FF4500"
    }
}

-- Simple highlight function
local function set_hl(group, opts)
    api.nvim_set_hl(0, group, opts)
end

-- Create glow effect
local function set_neon(group, color)
    -- Main text
    set_hl(group, {
        fg = color,
        bg = color,
        bold = true,
        blend = 90,
    })
    
    -- Wide background glow
    vim.cmd(string.format([[
        syn match %sWide /\k\+\s*\k*/ contains=%s
        hi %sWide guibg=%s gui=NONE blend=98
    ]], group, group, group, color))
end

-- Basic colors
local syntax = {
    NeonKeyword = colors.neon.pink,
    NeonFunction = colors.neon.blue,
    NeonString = colors.neon.green,
    NeonComment = colors.neon.purple,
    NeonType = colors.neon.yellow,
    NeonConstant = colors.neon.orange,
}

-- Apply effects
for group, color in pairs(syntax) do
    set_neon(group, color)
end

-- Link to standard groups
vim.cmd([[
    hi! link Keyword NeonKeyword
    hi! link Function NeonFunction
    hi! link String NeonString
    hi! link Comment NeonComment
    hi! link Type NeonType
    hi! link Constant NeonConstant
]])

-- UI elements
set_hl("Normal", { bg = colors.bg, fg = colors.fg })

-- Cursor line with glow
set_hl("CursorLine", {
    bg = colors.neon.blue,
    blend = 95,
})

set_hl("CursorLineNr", {
    fg = colors.neon.blue,
    bold = true,
})

-- Visual selection with glow
set_hl("Visual", {
    bg = colors.neon.purple,
    blend = 90,
})

-- Search with glow
set_hl("Search", {
    bg = colors.neon.pink,
    blend = 85,
})

-- Better line numbers
set_hl("LineNr", {
    fg = colors.neon.blue,
    blend = 50,
})

-- Status line with glow
set_hl("StatusLine", {
    bg = colors.neon.blue,
    blend = 90,
})

-- Window separator with glow
set_hl("WinSeparator", {
    fg = colors.neon.blue,
    bold = true,
})

-- Ensure everything is enabled
vim.opt.cursorline = true

-- Keep effects fresh
vim.cmd([[
    augroup NeonEffect
        autocmd!
        autocmd InsertEnter * hi CursorLine guibg=#FF1493 blend=90
        autocmd InsertLeave * hi CursorLine guibg=#00FFFF blend=95
    augroup END
]])

-- Update syntax frequently
vim.cmd("syntax sync minlines=500")

return colors