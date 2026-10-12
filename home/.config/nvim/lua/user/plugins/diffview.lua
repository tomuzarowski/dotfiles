return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Diff working tree" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
	},
}
