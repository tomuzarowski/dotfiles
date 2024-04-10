return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons"
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
                    }
                },
                file_ignore_patterns = {
                    "node_modules",
                    "yarn.lock",
                    ".git",
                },
            }
        })

        telescope.load_extension("fzf")

        local keymap = vim.keymap

        keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files in cwd" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Show open buffers in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>ff", "<cmd>Telescope git_files<CR>", { desc = "Find in git files" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Show recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
    end
}
