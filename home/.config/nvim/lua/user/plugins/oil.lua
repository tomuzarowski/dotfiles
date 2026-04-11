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
	dependencies = {
		{
			"echasnovski/mini.icons",
			opts = {},
			config = function(_, opts)
				local icons = require("mini.icons")
				icons.setup(opts)
				-- Provide backward compatibility for plugins that expect nvim-web-devicons
				icons.mock_nvim_web_devicons()
			end,
		},
	},
	lazy = false,
	keys = {
		{ "-", ":Oil --float<CR>", desc = "Open parent directory" },
	},
}
