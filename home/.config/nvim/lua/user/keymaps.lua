-- Clear search highlighting.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Close all open buffers.
vim.keymap.set("n", "<leader>q", "<cmd>%bdelete<CR>", { desc = "Delete all buffers" })

-- Save file.
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>", { desc = "Save file" })

-- Maintain the cursor position when yanking a visual selection.
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
-- Visual mode only ("x", not "v"), so typing into a snippet placeholder in select mode is not hijacked.
vim.keymap.set("x", "y", "myy`y")
vim.keymap.set("x", "Y", "myY`y")

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Paste replace visual selection without copying it (native v_P, also correct at the end of a line).
vim.keymap.set("x", "p", "P")

-- Move selected lines down/up and reindent them.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move lines down" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move lines up" })

-- Disable annoying command line thing.
vim.keymap.set("n", "q:", ":q<CR>")

-- Resize with arrows.
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Split windows.
vim.keymap.set("n", "<leader>vs", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>vh", "<cmd>split<CR>", { desc = "Split window horizontally" })
