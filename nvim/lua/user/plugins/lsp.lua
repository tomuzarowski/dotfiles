return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				height = 0.8,
			},
		})
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"astro",
				"cssls",
				"emmet_ls",
				"html",
				"intelephense",
				"lua_ls",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"phpactor",
				"vue_ls",
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint_d",
				"prettier",
				"stylua",
				"pint",
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		-- PHP
		vim.lsp.config("intelephense", {
			commands = {
				IntelephenseIndex = {
					function()
						vim.lsp.buf.execute_command({ command = "intelephense.index.workspace" })
					end,
				},
			},
			capabilities = capabilities,
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "intelephense" })

		vim.lsp.config("phpactor", {
			capabilities = capabilities,
		})
		vim.lsp.enable({ "phpactor" })

		-- Vue, JavaScript, TypeScript
		vim.lsp.config("vue_ls", {
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			capabilities = capabilities,
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "vue_ls" })

		vim.lsp.config("ts_ls", {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
						languages = { "javascript", "typescript", "vue" },
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
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "ts_ls" })

		-- Tailwind CSS
		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "tailwindcss" })

		-- JSON
		vim.lsp.config("jsonls", {
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
				},
			},
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "jsonls" })

		-- Lua
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = {
							"${3rd}/luv/library",
							unpack(vim.api.nvim_get_runtime_file("", true)),
						},
					},
				},
			},
			flags = { debounce_text_changes = 300 },
		})
		vim.lsp.enable({ "lua_ls" })

		-- Keymaps
		vim.keymap.set("n", "<Leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
		vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
		vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
		vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>")
		vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
		vim.keymap.set("n", "<Leader>lr", ":LspRestart<CR>", { silent = true })
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
		vim.keymap.set("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })

		-- Diagnostic configuration
		vim.diagnostic.config({
			virtual_text = false,
			float = {
				source = true,
			},
		})

		-- Sign configuration
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
				-- values = {
				-- 	{ name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
				-- 	{ name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn" },
				-- 	{ name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo" },
				-- 	{ name = "DiagnosticSignHint", text = "", texthl = "DiagnosticSignHint" },
				-- },
			},
		})
	end,
}
