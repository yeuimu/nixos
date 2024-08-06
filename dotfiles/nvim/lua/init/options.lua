-- Enable system clipboard
vim.opt.clipboard = 'unnamedplus'
-- utf8
vim.opt.encoding = 'UTF-8'
vim.opt.fileencoding = 'utf-8'
-- 使用相对行号
vim.opt.number = true
vim.opt.relativenumber = true
-- 高亮所在行
vim.opt.cursorline = true
-- 当文件被外部程序修改时，自动加载
vim.opt.autoread = true
vim.opt.autoread = true
-- 折行
vim.opt.wrap = true

-- tab => space*2
vim.opt.tabstop = 2      -- 设置tab为2个空格的等效宽度
vim.opt.expandtab = true -- 设置按下tab键时插入空格
vim.opt.shiftwidth = 2   -- 设置自动缩进时使用的空格数
vim.opt.softtabstop = 2  -- 设置按下退格键时处理空格的方式

-- 折叠层级
vim.opt.foldlevel = 99
vim.opt.conceallevel = 2
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99

-- 快捷键反应时间
vim.opt.timeoutlen = 1500

-- 将新窗口放到旧窗口之下
vim.opt.sb = true

-- Make a buffer modifiable
vim.opt.ma = true

-- Add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
