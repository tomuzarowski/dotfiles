return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = {
    options = {
      section_separators = '',
      component_separators = '',
      globalstatus = true,
      theme = function()
        local palette = require('rose-pine.palette')
        return {
          normal = {
            a = { fg = palette.foam, bg = 'NONE' },
            b = { bg = 'NONE' },
            c = { bg = 'NONE' },
          },
          insert = {
            a = { fg = palette.pine, bg = 'NONE' },
          },
          visual = {
            a = { fg = palette.iris, bg = 'NONE' },
          },
          replace = {
            a = { fg = palette.love, bg = 'NONE' },
          },
          command = {
            a = { fg = palette.gold, bg = 'NONE' },
          },
        }
      end,
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
          color = function()
            return { fg = require('rose-pine.palette').rose }
          end,
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
