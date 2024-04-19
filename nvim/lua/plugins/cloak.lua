return {
	"laytan/cloak.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("cloak").setup()
	end,
}
