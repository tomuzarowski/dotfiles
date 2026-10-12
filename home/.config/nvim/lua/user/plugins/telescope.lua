return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
	},
	init = function()
		-- Code actions and other vim.ui.select prompts load telescope; ui-select then takes over
		local native_select = vim.ui.select
		local function lazy_select(...)
			require("lazy").load({ plugins = { "telescope.nvim" } })
			if vim.ui.select == lazy_select then
				vim.ui.select = native_select
			end
			return vim.ui.select(...)
		end
		vim.ui.select = lazy_select
	end,
	keys = {
		{
			"<C-p>",
			function()
				require("telescope.builtin").find_files({ hidden = true })
			end,
			desc = "Find files, including hidden",
		},
		{ "<C-b>", "<cmd>Telescope buffers<CR>", desc = "Show open buffers in cwd" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Show open buffers in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor in cwd" },
		{ "<leader>ff", "<cmd>Telescope git_files<CR>", desc = "Find in git files" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Show recent files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Find string in cwd" },
		{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find todos" },
		{ "<leader>fl", "<cmd>Telescope resume<CR>", desc = "Find last search" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
		{ "<leader>fo", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find symbols in file" },
		{ "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find symbols in workspace" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = {
					"node_modules/",
					"yarn.lock",
					"^%.git/",
				},
			},
			pickers = {
				oldfiles = {
					only_cwd = true,
				},
			},
			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown(),
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,
}
