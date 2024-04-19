return {
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("illuminate").configure({
				under_cursor = true,
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				filetypes_denylist = {
					"DressingSelect",
					"Outline",
					"TelescopePrompt",
					"alpha",
					"harpoon",
					"toggleterm",
					"neo-tree",
					"Spectre",
				},
			})
		end,
	},
}
