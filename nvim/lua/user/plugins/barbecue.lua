return {
  'utilyre/barbecue.nvim',
  event = 'BufRead',
  dependencies = {
    {
      "SmiteshP/nvim-navic",
      opts = {
        lsp = {
          auto_attach = true,
          preference = { "intelephense" },
        }
      },
    },
    { "echasnovski/mini.icons", opts = {} },
  },
  opts = {
    theme = 'tokyonight',
  },
}
