return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- vertical popup with a border in the bottom-right corner
    preset = "helix",
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>n", group = "neogit" },
      { "<leader>q", group = "quit" },
      { "<leader>r", group = "rename" },
      { "<leader>u", group = "toggle" },
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
