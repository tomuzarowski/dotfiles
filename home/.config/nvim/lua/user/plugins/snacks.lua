return {
	"folke/snacks.nvim",
	-- early, so the notifier takes over vim.notify before other plugins use it
	lazy = false,
	priority = 1000,
	opts = {
		notifier = { enabled = true },
		-- Animated scrolling instead of jumping half a screen at a time.
		scroll = { enabled = true },
		-- Indent guides with an animated current scope. Replaces indent-blankline.nvim.
		indent = {
			enabled = true,
			indent = { char = "┊" },
			scope = { char = "┊" },
			animate = { duration = { step = 18, total = 375 } },
		},
		-- Use Neovim's native sign column.
		statuscolumn = { enabled = false },
		-- Rounded floating prompt for vim.ui.input (e.g. LSP rename).
		input = { enabled = true },
		-- Fuzzy finder + vim.ui.select replacement.
		picker = {
			enabled = true,
			ui_select = true,
			sources = {
				files = {
					exclude = { "node_modules", "yarn.lock", ".git" },
				},
				grep = {
					exclude = { "node_modules", "yarn.lock", ".git" },
				},
			},
		},
		-- Highlight references to the symbol under the cursor.
		words = { enabled = true },
		-- Keep the UI responsive in huge files.
		bigfile = { enabled = true },
		quickfile = { enabled = true },
	},
	keys = {
		{ "<C-p>", function() Snacks.picker.files({ hidden = true }) end, desc = "Find files, including hidden" },
		{ "<C-b>", function() Snacks.picker.buffers() end, desc = "Show open buffers in cwd" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Show open buffers in cwd" },
		{ "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find string under cursor in cwd", mode = { "n", "x" } },
		{ "<leader>ff", function() Snacks.picker.git_files() end, desc = "Find in git files" },
		{ "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Show recent files" },
		{ "<leader>fs", function() Snacks.picker.grep() end, desc = "Find string in cwd" },
		{ "<leader>fl", function() Snacks.picker.resume() end, desc = "Find last search" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Find diagnostics" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Find help" },
		{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
		{ "<leader>fo", function() Snacks.picker.lsp_symbols() end, desc = "Find symbols in file" },
		{ "<leader>fw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Find symbols in workspace" },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- Global, unlike Snacks.toggle.inlay_hints(), which only covers the current buffer
		Snacks.toggle
			.new({
				name = "Inlay Hints",
				get = function()
					return vim.lsp.inlay_hint.is_enabled()
				end,
				set = function(state)
					vim.lsp.inlay_hint.enable(state)
				end,
			})
			:map("<leader>uh")

		-- Copilot ghost text; <Tab> accepts it (see blink.lua)
		Snacks.toggle
			.new({
				name = "Copilot Suggestions",
				get = function()
					return vim.lsp.inline_completion.is_enabled()
				end,
				set = function(state)
					vim.lsp.inline_completion.enable(state)
				end,
			})
			:map("<leader>uc")

		-- Read by format_on_save in conform.lua
		Snacks.toggle
			.new({
				name = "Format on Save (Buffer)",
				get = function()
					return not vim.b.disable_autoformat
				end,
				set = function(state)
					vim.b.disable_autoformat = not state
				end,
			})
			:map("<leader>uf")
		Snacks.toggle
			.new({
				name = "Format on Save (Global)",
				get = function()
					return not vim.g.disable_autoformat
				end,
				set = function(state)
					vim.g.disable_autoformat = not state
				end,
			})
			:map("<leader>uF")

		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		Snacks.toggle.scroll():map("<leader>uS")
		Snacks.toggle.indent():map("<leader>uI")
		Snacks.toggle.dim():map("<leader>uD")
		Snacks.toggle.zen():map("<leader>uz")
		Snacks.toggle.zoom():map("<leader>uZ")
	end,
}
