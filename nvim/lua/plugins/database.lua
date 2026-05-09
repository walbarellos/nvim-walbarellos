-- lua/plugins/database.lua
-- SQL (PostgreSQL) e Docker para LicitaCidadão / Vigília / Sentinela
-- Coloca em: nvim/lua/plugins/database.lua

return {
    -- vim-dadbod: cliente SQL interativo direto no Neovim
    -- Conecta no PostgreSQL, SQLite, etc.
    {
        "tpope/vim-dadbod",
        lazy = true,
        cmd = { "DB" },
    },

    -- UI do dadbod: explorador de tabelas, execução de queries
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        keys = {
            { "<leader>Db", "<cmd>DBUIToggle<cr>",        desc = "Database: abre DBUI" },
            { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Database: adiciona conexão" },
        },
        init = function()
            -- Pasta onde o dadbod salva queries
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_queries"
            -- Mostra notificação ao executar query
            vim.g.db_ui_execute_on_save = 0
            -- Ícones da UI
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },

    -- Autocomplete de SQL no nvim-cmp (já está na config base)
    -- A extensão vim-dadbod-completion cuida disso quando está em buffer SQL

    -- Docker Compose language service via LSP
    -- Instala via Mason: docker_compose_language_service + dockerls
    -- Adiciona no lsp.lua -> servers existente:
    --   dockerls = {}
    --   docker_compose_language_service = {}

    -- Highlight para SQL e YAML (já cobertos pelo Treesitter base)
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, {
                    "sql",
                    "dockerfile",
                })
            end
        end,
    },
}
