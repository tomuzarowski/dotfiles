return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = {
    options = {
      section_separators = '',
      component_separators = '',
      globalstatus = true,
      theme = {
        normal = {
          a = { fg = '#7aa2f7', bg = 'NONE' },
          b = { bg = 'NONE' },
          c = { bg = 'NONE' },
        },
        insert = {
          a = { fg = '#9ece6a', bg = 'NONE' },
        },
        visual = {
          a = { fg = '#bb9af7', bg = 'NONE' },
        },
        replace = {
          a = { fg = '#f7768e', bg = 'NONE' },
        },
        command = {
          a = { fg = '#e0af68', bg = 'NONE' },
        },
      },
    },
    sections = {
      lualine_a = {
        'mode',
      },
      lualine_b = {
        'branch',
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
        function ()
          return '󰅭 ' .. #vim.lsp.get_clients({ bufnr = 0 })
        end,
        { 'diagnostics', sources = { 'nvim_diagnostic' } },
      },
      lualine_c = {
        'filename'
      },
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = {
        'filetype',
        'encoding',
        'fileformat',
        '(vim.bo.expandtab and "␠ " or "⇥ ") .. vim.bo.shiftwidth',
      },
      lualine_z = {
        'searchcount',
        'selectioncount',
        'location',
        'progress',
      },
    },
  },
}
