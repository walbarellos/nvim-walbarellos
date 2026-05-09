-- =============================================================================
-- FORMATAÇÃO E LINTING (lua/plugins/formatting.lua)
-- =============================================================================
-- Conform: formata o código ao salvar (clang-format, black, prettier, etc.)
-- nvim-lint: roda linters em tempo real (cppcheck, pylint, etc.)
--
-- Atalhos:
--   <Space>cf = formata arquivo
--   <Space>cl = roda linter manualmente

return {

    -- =========================================================================
    -- CONFORM - formatação
    -- =========================================================================
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd   = { "ConformInfo" },
        keys  = {
            {
                "<leader>cf",
                function()
                    require("conform").format({
                        async     = true,
                        lsp_fallback = true,  -- usa LSP se não tiver formatter
                    })
                end,
                mode = { "n", "v" },
                desc = "Formata arquivo/seleção",
            },
        },
        opts = {
            -- Formatters por tipo de arquivo
            formatters_by_ft = {
                lua        = { "stylua" },
                python     = { "isort", "black" },   -- isort ordena imports, black formata
                javascript = { "prettier" },
                typescript = { "prettier" },
                html       = { "prettier" },
                css        = { "prettier" },
                json       = { "prettier" },
                yaml       = { "prettier" },
                markdown   = { "prettier" },
                c          = { "clang_format" },
                cpp        = { "clang_format" },
                bash       = { "shfmt" },
                sh         = { "shfmt" },
                kotlin     = { "ktlint" },
                sql        = { "sql_formatter" },
                toml       = { "taplo" },
            },

            -- Formata ao salvar
            format_on_save = {
                timeout_ms   = 2000,       -- desiste se demorar mais de 2s
                lsp_fallback = true,
            },

            -- Configurações específicas de formatters
            formatters = {
                clang_format = {
                    prepend_args = {
                        "--style={BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 100}",
                    },
                },
                black = {
                    prepend_args = { "--line-length", "100" },
                },
            },
        },
    },

    -- =========================================================================
    -- NVIM-LINT - linting
    -- =========================================================================
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python     = { "ruff" },    -- ruff é muito mais rápido que pylint
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                -- C/C++: usa clangd + clang-tidy (configurado no lsp.lua)
                -- cppcheck não está no Mason; use :Mason pra instalar cpplint se quiser
                bash       = { "shellcheck" },
                sh         = { "shellcheck" },
                dockerfile = { "hadolint" },
            }

            -- Roda o linter ao salvar e ao entrar no buffer
            local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group    = lint_group,
                callback = function()
                    -- Só roda se o linter estiver instalado
                    pcall(lint.try_lint)
                end,
            })

            -- Atalho pra rodar manualmente
            vim.keymap.set("n", "<leader>cl", function()
                lint.try_lint()
            end, { desc = "Roda linter" })
        end,
    },

    -- =========================================================================
    -- MASON-TOOL-INSTALLER - instala formatters e linters via Mason
    -- =========================================================================
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                -- Formatters
                "stylua",      -- Lua
                "black",       -- Python
                "isort",       -- Python imports
                "ruff",        -- Python linter/formatter
                "prettier",    -- JS/TS/HTML/CSS/JSON/YAML/MD
                "clang-format",-- C/C++
                "shfmt",       -- Shell
                "ktlint",      -- Kotlin
                "sql-formatter", -- SQL
                "taplo",       -- TOML
                -- Linters
                -- "cpplint",   -- C/C++ (opcional, instale via :Mason se quiser)
                "shellcheck",  -- Shell
                "eslint_d",    -- JS/TS (versão daemon, muito rápida)
                "hadolint",    -- Dockerfile
            },
            auto_update = false,
            run_on_start = true,
        },
    },

}
