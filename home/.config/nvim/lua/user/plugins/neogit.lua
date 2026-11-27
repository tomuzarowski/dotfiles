return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>ng", "<cmd>Neogit<CR>", desc = "Open Neogit" },
  },
  opts = {
    integrations = {
      snacks = true,
    },
  },
}
