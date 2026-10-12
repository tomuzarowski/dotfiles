-- Editable quickfix list: change the lines and :w applies the edits to the files,
-- e.g. after sending live_grep results to it with <C-q>.
return {
	"stevearc/quicker.nvim",
	ft = "qf",
	keys = {
		{ "<leader>xq", function() require("quicker").toggle() end, desc = "Toggle quickfix" },
		{ "<leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle loclist" },
	},
	opts = {
		keys = {
			{
				">",
				function()
					require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
				end,
				desc = "Expand quickfix context",
			},
			{
				"<",
				function()
					require("quicker").collapse()
				end,
				desc = "Collapse quickfix context",
			},
		},
	},
}
