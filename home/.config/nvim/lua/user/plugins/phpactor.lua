return {
	"phpactor/phpactor",
	build = "composer install --no-dev --optimize-autoloader",
	ft = "php",
	keys = {
		{ "<Leader>pm", "<cmd>PhpactorContextMenu<CR>", desc = "Context menu" },
		{ "<Leader>pn", "<cmd>PhpactorClassNew<CR>", desc = "New class" },
	},
}
