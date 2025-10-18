return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 1000,
			-- lsp_format = "fallback",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				css = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				php = { "pint" },
				svelte = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})
	end,
}
