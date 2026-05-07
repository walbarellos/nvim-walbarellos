-- =============================================================================
-- TREESITTER (lua/plugins/treesitter.lua)
-- =============================================================================
-- O motor de sintaxe que entende seu código.
-- Fornece destaque de cores (highlight), dobras (folds) e seleção inteligente.

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- usa o commit mais recente
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
