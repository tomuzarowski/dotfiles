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
        vim.keymap.set({ 'x', 'o' }, 'ic', function()
          select.select_textobject('@class.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ac', function()
          select.select_textobject('@class.outer', 'textobjects')
        end)

        local move = require('nvim-treesitter-textobjects.move')
        vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
          move.goto_next_start('@function.outer', 'textobjects')
        end, { desc = 'Next function' })
        vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
          move.goto_previous_start('@function.outer', 'textobjects')
        end, { desc = 'Previous function' })
        vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
          move.goto_next_start('@class.outer', 'textobjects')
        end, { desc = 'Next class' })
        vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
          move.goto_previous_start('@class.outer', 'textobjects')
        end, { desc = 'Previous class' })
      end,
    },
  },
  config = function()
    require('nvim-treesitter').setup()

    require('nvim-treesitter').install({
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
      'jsdoc',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'php',
      'php_only',
      'phpdoc',
      'query',
      'regex',
      'scss',
      'sql',
      'svelte',
      'tsx',
      'twig',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
      'xml',
      'yaml',
    })

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'start treesitter highlighting',
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'use treesitter indentation for php (indent/php.vim relies on regex syntax)',
      group = vim.api.nvim_create_augroup('treesitter-indent', { clear = true }),
      pattern = { 'php' },
      callback = function(args)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
