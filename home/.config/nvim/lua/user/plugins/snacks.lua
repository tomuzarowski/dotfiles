return {
	"folke/snacks.nvim",
	-- early, so the notifier takes over vim.notify before other plugins use it
	lazy = false,
	priority = 1000,
	opts = {
		notifier = { enabled = true },
		-- Animated scrolling instead of jumping half a screen at a time.
		scroll = { enabled = true },
		-- Indent guides with an animated, underlined current scope. Replaces indent-blankline.nvim.
		indent = {
			enabled = true,
			indent = { char = "┊" },
			scope = { underline = true },
			animate = { duration = { step = 12, total = 250 } },
		},
		-- Line numbers, git signs, diagnostics and folds in a single column.
		statuscolumn = { enabled = true },
		-- Rounded floating prompt for vim.ui.input (e.g. LSP rename).
		input = { enabled = true },
		-- Highlight references to the symbol under the cursor.
		words = { enabled = true },
		-- Keep the UI responsive in huge files.
		bigfile = { enabled = true },
		quickfile = { enabled = true },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- The statuscolumn caches signs for 50ms (statuscolumn.refresh), so git signs placed just
		-- after a buffer is drawn stay hidden until the cursor moves. Redraw once the cache expires.
		vim.api.nvim_create_autocmd("User", {
			pattern = "GitSignsUpdate",
			group = vim.api.nvim_create_augroup("statuscolumn-git-signs", { clear = true }),
			callback = function(args)
				local buf = args.data and args.data.buffer
				if not buf then
					return
				end
				vim.defer_fn(function()
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim__redraw({ buf = buf, statuscolumn = true })
					end
				end, 60)
			end,
		})

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
