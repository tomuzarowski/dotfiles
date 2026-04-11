vim.api.nvim_create_autocmd('FileType', {
  desc = 'enable wrap for markdown and text files',
  group = vim.api.nvim_create_augroup('wrap-text-files', { clear = true }),
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd('textyankpost', {
  desc = 'highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})
