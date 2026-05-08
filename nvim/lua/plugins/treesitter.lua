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
        config = function()
            -- Lógica robusta para encontrar o módulo de configuração
            local configs = nil
            local mods = { "nvim-treesitter.configs", "nvim-treesitter.config", "nvim-treesitter" }

            for _, mod in ipairs(mods) do
                local ok, m = pcall(require, mod)
                if ok and m.setup then
                    configs = m
                    break
                end
            end

            if configs then
                configs.setup({
                    highlight = { enable = true },
                    indent = { enable = true },
                    ensure_installed = {
                        "bash", "c", "cpp", "html", "javascript", "json", "lua", "markdown",
                        "markdown_inline", "python", "query", "regex", "typescript", "vim",
                        "vimdoc", "yaml",
                    },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<C-space>",
                            node_incremental = "<C-space>",
                            node_decremental = "<bs>",
                        },
                    },
                })
            end
        end,
    },
}
