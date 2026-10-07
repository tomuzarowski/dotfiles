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
    vim.hl.on_yank({ timeout = 100 })
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'cd to the git root once on startup',
  group = vim.api.nvim_create_augroup('git-root-cwd', { clear = true }),
  callback = function()
    local root = vim.fs.root(vim.fn.expand('%:p:h'), '.git') or vim.fs.root(vim.fn.getcwd(), '.git')
    if root then
      vim.fn.chdir(root)
    end
  end,
})

local transparent_groups = {
  'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder', 'FloatTitle',
  'SignColumn', 'FoldColumn', 'LineNr', 'CursorLineNr', 'EndOfBuffer',
  'WinSeparator', 'VertSplit', 'MsgArea',
  'TelescopeNormal', 'TelescopeBorder', 'TelescopePromptNormal', 'TelescopePromptBorder',
  'TelescopeResultsNormal', 'TelescopeResultsBorder', 'TelescopePreviewNormal', 'TelescopePreviewBorder',
  'WhichKeyNormal', 'WhichKeyFloat',
  'GitSignsAdd', 'GitSignsChange', 'GitSignsDelete',
  'DiagnosticSignError', 'DiagnosticSignWarn', 'DiagnosticSignInfo', 'DiagnosticSignHint',
}

local function clear_backgrounds()
  for _, group in ipairs(transparent_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg, hl.ctermbg = nil, nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'make background transparent regardless of colorscheme',
  group = vim.api.nvim_create_augroup('transparent-background', { clear = true }),
  callback = clear_backgrounds,
})
