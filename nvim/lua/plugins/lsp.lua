-- =============================================================================
-- LSP (lua/plugins/lsp.lua)
-- =============================================================================
-- Language Server Protocol: erros em tempo real, go-to-definition,
-- rename, code actions, hover docs, etc.
--
-- NOTA: nvim-lspconfig v3.x mudou a API.
--   Antigo (deprecated): require('lspconfig').clangd.setup({})
--   Novo:                vim.lsp.config('clangd', {}) + vim.lsp.enable('clangd')
--
-- Mason instala os servidores automaticamente.
-- mason-lspconfig faz a ponte entre Mason e lspconfig.

return {

    -- =========================================================================
    -- MASON - instala LSPs, formatters, linters
    -- :Mason pra abrir a interface
    -- =========================================================================
    {
        "williamboman/mason.nvim",
        cmd   = "Mason",
        build = ":MasonUpdate",
        opts  = {
            ui = {
                border = "rounded",
                icons  = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- =========================================================================
    -- MASON-LSPCONFIG - integra Mason com lspconfig
    -- =========================================================================
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            -- Instala automaticamente ao abrir nvim
            ensure_installed = {
                "clangd",        -- C/C++
                "basedpyright",  -- Python
                "lua_ls",        -- Lua (pra editar config nvim)
                "ts_ls",         -- TypeScript/JavaScript
                "html",          -- HTML
                "cssls",         -- CSS
                "jsonls",        -- JSON
                "yamlls",        -- YAML
                "bashls",        -- Bash/Shell
                "marksman",      -- Markdown
                "kotlin_language_server", -- Kotlin/Android
                "dockerls",      -- Dockerfile
                "docker_compose_language_service", -- docker-compose.yml
                "sqls",          -- SQL/PostgreSQL
                "taplo",         -- TOML
            },
            automatic_enable = true,   -- nova API: habilita servidores automaticamente
        },
    },

    -- =========================================================================
    -- NVIM-LSPCONFIG - configura os servidores
    -- =========================================================================
    {
        "neovim/nvim-lspconfig",
        event        = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/SchemaStore.nvim",
        },
        config = function()
            -- ---------------------------------------------------------------
            -- CAPACIDADES (o que o nvim suporta)
            -- ---------------------------------------------------------------
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- ---------------------------------------------------------------
            -- ON_ATTACH - roda quando LSP conecta num buffer
            -- ---------------------------------------------------------------
            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, {
                        buffer = bufnr,
                        desc   = "LSP: " .. desc,
                        silent = true,
                    })
                end

                -- Navegação
                map("gd",  vim.lsp.buf.definition,     "Ir pra definição")
                map("gD",  vim.lsp.buf.declaration,    "Ir pra declaração")
                map("gi",  vim.lsp.buf.implementation, "Ir pra implementação")
                map("gt",  vim.lsp.buf.type_definition,"Ir pro tipo")
                map("gr",  "<cmd>Telescope lsp_references<cr>", "Ver referências")

                -- Documentação
                map("K",    vim.lsp.buf.hover,          "Documentação hover")
                map("<C-k>",vim.lsp.buf.signature_help, "Assinatura")

                -- Ações
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("<leader>rn", vim.lsp.buf.rename,      "Renomeia símbolo")
                map("<leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, "Formata arquivo")

                -- Diagnósticos
                map("[d",         vim.diagnostic.goto_prev,  "Erro anterior")
                map("]d",         vim.diagnostic.goto_next,  "Próximo erro")
                map("<leader>cd", vim.diagnostic.open_float, "Ver erro")
                map("<leader>cl", "<cmd>Telescope diagnostics<cr>", "Lista erros")
            end

            -- ---------------------------------------------------------------
            -- APARÊNCIA DOS DIAGNÓSTICOS
            -- ---------------------------------------------------------------
            vim.diagnostic.config({
                virtual_text     = { prefix = "●", spacing = 4 },
                signs            = true,
                underline        = true,
                update_in_insert = false,
                severity_sort    = true,
                float            = { border = "rounded", source = "always" },
            })

            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- ---------------------------------------------------------------
            -- CONFIGURAÇÃO DOS SERVIDORES (nova API vim.lsp.config)
            -- ---------------------------------------------------------------

            -- C/C++
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                on_attach    = on_attach,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                root_markers = {
                    "compile_commands.json", "compile_flags.txt",
                    "CMakeLists.txt", ".git",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                init_options = {
                    usePlaceholders    = true,
                    completeUnimported = true,
                },
            })

            -- Python
            vim.lsp.config("basedpyright", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths        = true,
                            diagnosticMode         = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode       = "basic",
                        },
                    },
                },
            })

            -- Lua
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    Lua = {
                        runtime  = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                "${3rd}/luv/library",
                            },
                        },
                        completion  = { callSnippet = "Replace" },
                        diagnostics = { globals = { "vim" } },
                        telemetry   = { enable = false },
                    },
                },
            })

            -- TypeScript/JavaScript
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                        },
                    },
                },
            })

            -- HTML
            vim.lsp.config("html", {
                capabilities = capabilities,
                on_attach    = on_attach,
                filetypes    = { "html", "htmldjango" },
            })

            -- CSS
            vim.lsp.config("cssls", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

            -- JSON com schemas
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    json = {
                        schemas  = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

            -- YAML com schemas
            vim.lsp.config("yamlls", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    yaml = {
                        schemaStore = { enable = false, url = "" },
                        schemas     = require("schemastore").yaml.schemas(),
                    },
                },
            })

            -- Bash
            vim.lsp.config("bashls", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

            -- Markdown
            vim.lsp.config("marksman", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

            -- Kotlin/Android
            vim.lsp.config("kotlin_language_server", {
                capabilities = capabilities,
                on_attach    = on_attach,
                settings = {
                    kotlin = {
                        compiler = {
                            jvm = { target = "17" },
                        },
                        externalSources = {
                            useKlsScheme = true,
                            autoConvertToKotlin = true,
                        },
                    },
                },
            })

            -- Dockerfile
            vim.lsp.config("dockerls", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

            -- Docker Compose
            vim.lsp.config("docker_compose_language_service", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

            -- SQL/PostgreSQL
            vim.lsp.config("sqls", {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    on_attach(client, bufnr)
                end,
            })

            -- TOML
            vim.lsp.config("taplo", {
                capabilities = capabilities,
                on_attach    = on_attach,
            })

        end,
    },

    -- =========================================================================
    -- SCHEMASTORE - schemas pra JSON/YAML
    -- Autocompletar em package.json, docker-compose.yml, etc.
    -- =========================================================================
    { "b0o/SchemaStore.nvim", lazy = true },

    -- =========================================================================
    -- TROUBLE - lista bonita de erros/diagnósticos
    -- <Space>xx = erros do projeto
    -- <Space>xX = erros do arquivo atual
    -- =========================================================================
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd  = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnósticos (projeto)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnósticos (arquivo)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix" },
        },
        opts = {},
    },

    -- =========================================================================
    -- CLANGD EXTENSIONS - extras pra C/C++
    -- Inlay hints, type hierarchy, AST view
    -- =========================================================================
    {
        "p00f/clangd_extensions.nvim",
        ft   = { "c", "cpp" },
        opts = {},
    },

}
