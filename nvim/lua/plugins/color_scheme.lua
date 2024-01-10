return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			vim.cmd("colorscheme tokyonight-night"),
	-- 		})
	-- 	end,
	-- },
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "deep",
				highlights = {
					["@type"] = { fmt = "none" },
					["@constructor"] = { fmt = "none" },
				},
			})
			require("onedark").load()
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			integrations = {
	-- 				cmp = true,
	-- 				gitsigns = true,
	-- 				harpoon = true,
	-- 				illuminate = true,
	-- 				indent_blankline = {
	-- 					enabled = false,
	-- 					scope_color = "sapphire",
	-- 					colored_indent_levels = false,
	-- 				},
	-- 				mason = true,
	-- 				native_lsp = { enabled = true },
	-- 				notify = true,
	-- 				nvimtree = true,
	-- 				neotree = true,
	-- 				symbols_outline = true,
	-- 				telescope = true,
	-- 				treesitter = true,
	-- 				treesitter_context = true,
	-- 			},
	-- 		})
	--
	-- 		vim.cmd.colorscheme("catppuccin-macchiato")
	--
	-- 		-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
	-- 		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	-- 			vim.api.nvim_set_hl(0, group, {})
	-- 		end
	-- 	end,
	-- },
}
