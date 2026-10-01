vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.clipboard = "unnamedplus"

-- Quality of life
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true
vim.opt.inccommand = "split"
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Hide some unused UI chrome
vim.opt.shortmess:append("I")
vim.opt.shortmess:append("oO")
vim.opt.fillchars = { eob = " ", fold = " ", foldsep = " " }
vim.opt.list = false
