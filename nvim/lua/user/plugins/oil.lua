return {
	"stevearc/oil.nvim",
	opts = {
		-- Configuration for the floating window in oil.open_float
		float = {
			max_width = 0.9,
			max_height = 0.8,
		},
	},
	dependencies = { { "nvim-tree/nvim-web-devicons" }, { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	keys = {
		{ "-", ":Oil --float<CR>", desc = "Open parent directory" },
	},
}
