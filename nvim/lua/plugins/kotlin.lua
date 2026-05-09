-- lua/plugins/kotlin.lua
-- Suporte a Kotlin/Android para a stack do Willian
-- Coloca em: nvim/lua/plugins/kotlin.lua

return {
    -- Syntax highlight e indent via Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, {
                    "kotlin",
                    "groovy", -- build.gradle
                    "xml",    -- AndroidManifest, layouts
                    "toml",   -- Cargo/config
                })
            end
        end,
    },

    -- Kotlin runner: compila e roda arquivo .kt fora do Android
    {
        "stevearc/overseer.nvim",
        optional = true,
    },

}
