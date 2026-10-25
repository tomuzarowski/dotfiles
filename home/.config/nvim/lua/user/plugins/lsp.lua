return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
		-- loads first, so its completion capabilities reach every server (see blink.cmp/plugin/blink-cmp.lua)
		"saghen/blink.cmp",
	},
	config = function()
		-- PHP
		local licence_file = vim.fn.expand("~/intelephense/licence.txt")
		vim.lsp.config("intelephense", {
			filetypes = { "php", "blade" },
			get_language_id = function(_, filetype)
				return filetype == "blade" and "php" or filetype
			end,
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
				-- ts_ls provides the hints; vue_ls's empty reply can arrive first and stop them from drawing after a toggle
				client.server_capabilities.inlayHintProvider = false
			end,
		})

		vim.lsp.config("ts_ls", {
			init_options = {
				preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
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

		-- Svelte uses VS Code-style settings for its JavaScript and TypeScript hints.
		local script_inlay_hints = {
			parameterNames = { enabled = "all" },
			parameterTypes = { enabled = true },
			variableTypes = { enabled = true },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = true },
			enumMemberValues = { enabled = true },
		}
		vim.lsp.config("svelte", {
			settings = {
				javascript = { inlayHints = vim.deepcopy(script_inlay_hints) },
				typescript = { inlayHints = vim.deepcopy(script_inlay_hints) },
			},
		})

		-- Lua
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					hint = {
						enable = true,
						paramName = "All",
						paramType = true,
						setType = true,
						await = true,
					},
				},
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
				"blade-formatter",
			},
		})

		-- Off until toggled with <Leader>uh / <Leader>uc (see snacks.lua)
		vim.lsp.inlay_hint.enable(false)
		vim.lsp.inline_completion.enable(false)

		-- Keymaps (see also the defaults: grn, gra, grt, grx, gO, K, <C-w>d)
		vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
		vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
		vim.keymap.set("n", "<Leader>lr", "<cmd>lsp restart<CR>", { desc = "Restart LSP", silent = true })
		local navigation_maps = {
			{ "gd", "textDocument/definition", "lsp_definitions", "Go to definition" },
			{ "gri", "textDocument/implementation", "lsp_implementations", "Go to implementation" },
			{ "grr", "textDocument/references", "lsp_references", "Show references" },
		}
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				for _, map in ipairs(navigation_maps) do
					if client:supports_method(map[2], args.buf) then
						vim.keymap.set("n", map[1], "<cmd>Telescope " .. map[3] .. "<CR>", {
							buffer = args.buf,
							desc = map[4],
						})
					end
				end
			end,
		})
		vim.api.nvim_create_autocmd("LspDetach", {
			callback = function(args)
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(args.buf) then
						return
					end
					for _, map in ipairs(navigation_maps) do
						if #vim.lsp.get_clients({ bufnr = args.buf, method = map[2] }) == 0 then
							local mapping = vim.api.nvim_buf_get_keymap(args.buf, "n")
							for _, item in ipairs(mapping) do
								if item.lhs == map[1] and item.rhs and item.rhs:lower() == ("<cmd>Telescope " .. map[3] .. "<CR>"):lower() then
									vim.keymap.del("n", map[1], { buffer = args.buf })
									break
								end
							end
						end
					end
				end)
			end,
		})

		vim.diagnostic.config({
			virtual_text = false,
			-- Show the message inline, but only for the line under the cursor (]d and [d land on it);
			-- <Leader>d opens the full message in a float.
			virtual_lines = { current_line = true },
			severity_sort = true,
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
