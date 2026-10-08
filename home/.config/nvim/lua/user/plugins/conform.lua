return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	opts = {
		formatters_by_ft = {
			blade = { "blade-formatter" },
			css = { "prettier" },
			html = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			php = { "pint" },
			svelte = { "prettier" },
			vue = { "prettier" },
			twig = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "prettier" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 1000,
		},
	},
}
