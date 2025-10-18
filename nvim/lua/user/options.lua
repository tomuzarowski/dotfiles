vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true

vim.opt.termguicolors = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.breakindent = true
vim.opt.linebreak = true

vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }
vim.opt.fillchars:append({ eob = ' ' })

vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.confirm = true

vim.opt.undofile = true

vim.opt.wildmode = 'longest:full,full'
vim.opt.completeopt = 'menuone,longest,preview'

vim.opt.signcolumn = 'yes:2'

vim.opt.showmode = false

vim.opt.updatetime = 100   -- Decrease update time
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files

vim.opt.backspace = 'indent,eol,start'

vim.opt.cursorline = true

vim.opt.scrolloff = 2
