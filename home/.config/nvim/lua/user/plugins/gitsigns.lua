return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- Untracked files have no useful line-by-line diff yet.
		attach_to_untracked = false,
		on_attach = function(bufnr)
			-- Also skip new files already in the index (including git add -N).
			-- Only files present in HEAD should show line-by-line changes.
			local status = vim.b[bufnr].gitsigns_status_dict
			local root = status and status.root
			local path = root and vim.fs.relpath(root, vim.api.nvim_buf_get_name(bufnr))
			if path then
				local result = vim.system({ "git", "-C", root, "cat-file", "-e", "HEAD:" .. path }):wait()
				if result.code ~= 0 then
					return false
				end
			end

			local gitsigns = require("gitsigns")

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			map("n", "]h", function() gitsigns.nav_hunk("next") end, "Next hunk")
			map("n", "[h", function() gitsigns.nav_hunk("prev") end, "Previous hunk")
			map("n", "<leader>gj", function() gitsigns.nav_hunk("next") end, "Next hunk")
			map("n", "<leader>gk", function() gitsigns.nav_hunk("prev") end, "Previous hunk")

			-- Staging a staged hunk again unstages it
			map("n", "<leader>gs", gitsigns.stage_hunk, "Stage/unstage hunk")
			map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage/unstage selected lines")
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset selected lines")
			map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
			map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")

			map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Preview hunk")
			map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Blame line")
			map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle line blame")
			map("n", "<leader>gd", gitsigns.diffthis, "Diff against index")

			-- Hunk text object, e.g. dih, vih
			map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
		end,
	},
}
