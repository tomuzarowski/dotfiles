return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = { enabled = true, view = 'cmdline_popup' },
    -- Keep Blink completions, Snacks notifications and the existing LSP UI.
    popupmenu = { enabled = false },
    messages = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
    },
  },
}
