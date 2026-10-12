return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
		{
			"<leader>uf",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				vim.notify("Format on save for this buffer " .. (vim.b.disable_autoformat and "off" or "on"))
			end,
			desc = "Toggle format on save (buffer)",
		},
		{
			"<leader>uF",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
			end,
			desc = "Toggle format on save (global)",
		},
	},
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
		-- <leader>uf / <leader>uF turn it off, e.g. to keep diffs small in legacy files
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { lsp_format = "fallback", timeout_ms = 1000 }
		end,
	},
}
