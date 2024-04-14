return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",

	config = function()
		local harpoon = require("harpoon")

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })

		vim.keymap.set("n", "<leader>hr", function()
			harpoon:list():remove()
		end, { desc = "Remove file from harpoon" })

		vim.keymap.set("n", "<leader>ho", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Open harpoon menu" })

		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Select harpoon file 1" })

		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Select harpoon file 2" })

		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Select harpoon file 3" })

		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Select harpoon file 4" })

		vim.keymap.set("n", "<leader>5", function()
			harpoon:list():select(5)
		end, { desc = "Select harpoon file 5" })
	end,
}
