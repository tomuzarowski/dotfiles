return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find todos" },
  },
  opts = {}
}
