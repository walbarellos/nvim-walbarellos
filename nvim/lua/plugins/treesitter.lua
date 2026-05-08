-- =============================================================================
-- TREESITTER (lua/plugins/treesitter.lua)
-- =============================================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash", "c", "cpp", "html", "javascript", "json", "lua", "markdown",
                "markdown_inline", "python", "query", "regex", "typescript", "vim",
                "vimdoc", "yaml",
            },
        },
        config = function(_, opts)
            -- Tentativa moderna de setup
            local status, ts = pcall(require, "nvim-treesitter.configs")
            if not status then
                -- Fallback se o módulo estiver em outro lugar ou renomeado
                status, ts = pcall(require, "nvim-treesitter.config")
            end

            if status and ts.setup then
                ts.setup(opts)
            else
                -- Caso extremo: tenta carregar o diretório principal
                require("nvim-treesitter").setup(opts)
            end
        end,
    },
}
