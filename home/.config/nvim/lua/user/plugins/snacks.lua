return {
	"folke/snacks.nvim",
	-- early, so the notifier takes over vim.notify before other plugins use it
	lazy = false,
	priority = 1000,
	opts = {
		notifier = { enabled = true },
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
	end,
}
