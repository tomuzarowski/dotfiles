return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    keymap = {
      preset = 'enter',
      -- Copilot suggestion first, then snippet jump, then a regular tab
      ['<Tab>'] = {
        function() return vim.lsp.inline_completion.get() end,
        'snippet_forward',
        'fallback',
      },
    },
    completion = {
      list = { selection = { preselect = false } },
      documentation = { auto_show = true },
    },
    signature = { enabled = true },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    cmdline = {
      keymap = {
        preset = 'cmdline',
        -- same as in insert mode; falls back to command history when the menu is hidden
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
      },
      completion = {
        menu = { auto_show = true },
        -- nothing looks selected until you pick it, so <CR> runs exactly what is on the command line
        list = { selection = { preselect = false } },
      },
    },
  },
}
