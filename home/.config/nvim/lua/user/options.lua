vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = true

vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = '↪ '

vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }
vim.opt.fillchars:append({ eob = ' ', foldclose = '▸', diff = '╱' })

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.confirm = true

vim.opt.undofile = true

vim.opt.wildmode = 'longest:full,full'
vim.opt.completeopt = 'menuone,noselect,popup'

vim.opt.signcolumn = 'yes'

vim.opt.showmode = false

vim.opt.updatetime = 250   -- Decrease update time
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.opt.ttimeoutlen = 10  -- Shorter wait after <Esc> for a possible key sequence

vim.opt.cursorline = true
vim.opt.guicursor:append('o:hor50') -- Half-block cursor while waiting for a motion

vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true

vim.opt.winborder = 'rounded'
vim.opt.splitkeep = 'screen'

vim.opt.inccommand = 'split'
