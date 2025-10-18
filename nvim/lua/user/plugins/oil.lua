return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { "nvim-tree/nvim-web-devicons" }, { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
  keys = {
      { '-', ':Oil<CR>', desc = 'Open parent directory' },
  }
}
