return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
		vim.notify = require("notify")
		require("notify").setup({
			stages = "fade_in_slide_out",
			timeout = 1000,
			render = "minimal",
		})
	end,
}
