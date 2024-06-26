return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	-- tag = "v2.8.0",
	config = function()
		require("oil").setup({
			float = {
				border = "rounded",
				padding = 7,
			},
			vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" }),
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
