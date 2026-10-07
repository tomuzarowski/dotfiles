-- Use Neovim's native commenting (gc) with treesitter-aware commentstring
return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  event = 'VeryLazy',
  init = function()
    -- Skip backward-compat module to avoid deprecation warning
    vim.g.skip_ts_context_commentstring_module = true
  end,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
      languages = {
        php_only = '// %s',
        php = '// %s',
        -- the blade grammar inherits html, so this covers the markup parts
        blade = '{{-- %s --}}',
      },
    })

    -- Integrate with Neovim's native gc commenting
    local get_option = vim.filetype.get_option
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring"
        and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end

    -- Maintain cursor position when commenting a paragraph
    vim.keymap.set('n', 'gcap', 'my<cmd>norm vip<bar>gc<cr>`y')
  end,
}
