-- Syntax highlighting

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      config = function()
        require('nvim-treesitter-textobjects').setup({
          select = {
            lookahead = true,
          },
        })

        local select = require('nvim-treesitter-textobjects.select')
        vim.keymap.set({ 'x', 'o' }, 'if', function()
          select.select_textobject('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'af', function()
          select.select_textobject('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ia', function()
          select.select_textobject('@parameter.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'aa', function()
          select.select_textobject('@parameter.outer', 'textobjects')
        end)
      end,
    },
  },
  opts = {
    ensure_installed = {
      'bash',
      'blade',
      'comment',
      'css',
      'diff',
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'html',
      'ini',
      'javascript',
      'json',
      'jsonc',
      'lua',
      'markdown',
      'markdown_inline',
      'php',
      'php_only',
      'phpdoc',
      'query',
      'regex',
      'sql',
      'svelte',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
      'xml',
      'yaml',
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "yaml" }
    },
  },
  config = function (_, opts)
    vim.filetype.add({
      pattern = {
        ['.*%.blade%.php'] = 'blade',
      },
    })

    require('nvim-treesitter').setup(opts)
  end,
}
