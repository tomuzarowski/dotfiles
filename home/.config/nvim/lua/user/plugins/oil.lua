return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = true,
		float = {
			max_width = 0.9,
			max_height = 0.8,
		},
		view_options = {
			show_hidden = true,
		},
	},
	lazy = false,
	keys = {
		{ "-", "<cmd>Oil --float<CR>", desc = "Open parent directory" },
	},
}
