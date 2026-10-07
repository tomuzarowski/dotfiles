return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>l", group = "lsp" },
      { "<leader>n", group = "neogit" },
      { "<leader>p", group = "phpactor" },
      { "<leader>r", group = "rename" },
      { "<leader>v", group = "split" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
