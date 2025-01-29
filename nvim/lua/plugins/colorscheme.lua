return {
	-- {
	-- 	"dracula/vim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	config = function()
	-- 		vim.cmd("colorscheme dracula")
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				vim.cmd("colorscheme tokyonight-night"),
			})
		end,
	},
	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	config = function()
	-- 		require("onedark").setup({
	-- 			style = "deep",
	-- 			highlights = {
	-- 				["@type"] = { fmt = "none" },
	-- 				["@constructor"] = { fmt = "none" },
	-- 			},
	-- 		})
	-- 		require("onedark").load()
	-- 	end,
	-- },
	-- {
	-- 	"olivercederborg/poimandres.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("poimandres").setup({
	-- 			-- leave this setup function empty for default config
	-- 			-- or refer to the configuration section
	-- 			-- for configuration options
	-- 		})
	-- 	end,
	--
	-- 	-- optionally set the colorscheme within lazy config
	-- 	init = function()
	-- 		vim.cmd("colorscheme poimandres")
	-- 	end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			-- transparent_background = true,
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
	-- 		vim.cmd.colorscheme("catppuccin-mocha")
	--
	-- 		-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
	-- 		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	-- 			vim.api.nvim_set_hl(0, group, {})
	-- 		end
	-- 	end,
	-- },
}
