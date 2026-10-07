return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		-- PHP
		local licence_file = vim.fn.expand("~/intelephense/licence.txt")
		vim.lsp.config("intelephense", {
			init_options = {
				licenceKey = vim.fn.filereadable(licence_file) == 1 and vim.fn.readfile(licence_file)[1] or nil,
			},
			settings = {
				intelephense = {
					inlayHints = {
						parameterNames = { enabled = true },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionReturnTypes = { enabled = true },
					},
				},
			},
		})

		vim.api.nvim_create_user_command("IntelephenseIndex", function()
			local client = vim.lsp.get_clients({ name = "intelephense", bufnr = 0 })[1]
			if client then
				client:exec_cmd({ title = "Index workspace", command = "intelephense.index.workspace" })
			end
		end, { desc = "Reindex the intelephense workspace" })

		-- Vue, JavaScript, TypeScript
		vim.lsp.config("vue_ls", {
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		vim.lsp.config("ts_ls", {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
			},
		})

		-- JSON
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		-- Servers listed here are installed and enabled automatically.
		require("mason").setup({
			ui = {
				height = 0.8,
			},
		})
		require("mason-lspconfig").setup({
			automatic_enable = {
				-- installed in Mason as formatters/leftovers, not wanted as language servers
				exclude = { "biome", "emmet_ls", "stylua" },
			},
			ensure_installed = {
				"cssls",
				"emmet_language_server",
				"html",
				"intelephense",
				"jsonls",
				"lua_ls",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"vue_ls",
				"copilot", -- sign in once with :LspCopilotSignIn
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"pint",
			},
		})

		vim.lsp.inlay_hint.enable(true)

		-- Copilot ghost text; <Tab> accepts it (see blink.lua)
		vim.lsp.inline_completion.enable(true)

		-- Keymaps (see also the defaults: grn, gra, grt, grx, gO, K, <C-w>d)
		vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
		vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
		vim.keymap.set("n", "<Leader>lr", "<cmd>lsp restart<CR>", { desc = "Restart LSP", silent = true })
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to definition" })
		vim.keymap.set("n", "gri", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to implementation" })
		vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references<CR>", { desc = "Show references" })

		vim.diagnostic.config({
			virtual_text = false,
			float = {
				source = true,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})
	end,
}
