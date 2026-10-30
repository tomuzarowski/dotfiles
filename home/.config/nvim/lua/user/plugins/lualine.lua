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
          a = { fg = '#9ccfd8', bg = 'NONE' },
          b = { bg = 'NONE' },
          c = { bg = 'NONE' },
        },
        insert = {
          a = { fg = '#31748f', bg = 'NONE' },
        },
        visual = {
          a = { fg = '#c4a7e7', bg = 'NONE' },
        },
        replace = {
          a = { fg = '#eb6f92', bg = 'NONE' },
        },
        command = {
          a = { fg = '#f6c177', bg = 'NONE' },
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
          color = { fg = "#ebbcba" },
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
