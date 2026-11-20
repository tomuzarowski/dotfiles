return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	priority = 1000,
	opts = {
		variant = "dawn",
		-- variant = "main",
		styles = { transparency = true },
	},
	config = function(_, opts)
		vim.o.background = "light"
		-- vim.o.background = "dark"
		require("rose-pine").setup(opts)
		vim.cmd.colorscheme("rose-pine")
	end,
}
