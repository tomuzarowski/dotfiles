return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        -- Additional text objects for treesitter
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag"
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            highlight = {
                enable = true
            },
            indent = { enable = true },
            autotag = {
                enable = true
            },
            ensure_installed = {
                "astro",
                "bash",
                "css",
                "graphql",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "php",
                "svelte",
                "tsx",
                "typescript",
                "vue",
                "vim",
                "vimdoc",
                "twig",
            },
        })
    end,
}
