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
	},
	opts = {
		formatters_by_ft = {
			blade = { "blade-formatter" },
			css = { "prettier" },
			html = { "prettier" },
			javascript = { "vp_fmt", "prettier", stop_after_first = true },
			javascriptreact = { "vp_fmt", "prettier", stop_after_first = true },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			php = { "pint" },
			svelte = { "prettier" },
			vue = { "prettier" },
			twig = { "prettier" },
			typescript = { "vp_fmt", "prettier", stop_after_first = true },
			typescriptreact = { "vp_fmt", "prettier", stop_after_first = true },
			yaml = { "prettier" },
		},
		formatters = {
			-- Vite+ projects keep formatter options in vite.config.ts, which Prettier does not read
			vp_fmt = {
				command = function(self, ctx)
					return require("conform.util").from_node_modules("vp")(self, ctx)
				end,
				args = { "fmt", "--stdin-filepath", "$FILENAME" },
				stdin = true,
				cwd = function(self, ctx)
					return require("conform.util").root_file({ "vite.config.ts", "vite.config.js" })(self, ctx)
				end,
				require_cwd = true,
			},
		},
		-- <leader>uf / <leader>uF turn it off, e.g. to keep diffs small in legacy files (see snacks.lua)
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { lsp_format = "fallback", timeout_ms = 1000 }
		end,
	},
}
