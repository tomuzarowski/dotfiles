return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")

		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"astro",
				"cssls",
				"emmet_ls",
				"html",
				"intelephense",
				"lua_ls",
				"svelte",
				"tailwindcss",
				"tsserver",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"eslint_d",
				"prettier",
				"pretty-php",
				"stylua",
			},
		})
	end,
}
