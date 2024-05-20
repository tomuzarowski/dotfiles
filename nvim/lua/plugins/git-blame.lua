return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	config = function()
		require("gitblame").setup()
	end,
}
