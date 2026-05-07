-- =============================================================================
-- LSP (Language Server Protocol) (lua/plugins/lsp.lua)
-- =============================================================================
-- LSP = o sistema que dá superpoderes ao editor:
--   • Autocompletar com contexto real
--   • Erros e avisos em tempo real (sem compilar)
--   • Ir pra definição (gd)
--   • Encontrar todas as referências (gr)
--   • Renomear variável em todo o projeto (<leader>rn)
--   • Documentação ao passar o mouse (K)
--   • Formatação automática
--
-- MASON = gerenciador de LSPs. Ele baixa e instala os servidores automaticamente.
-- Você não precisa instalar clangd, pyright, etc. manualmente.

return {

    -- =========================================================================
    -- MASON (instalador de LSPs, formatters, linters)
    -- =========================================================================
    {
        "williamboman/mason.nvim",
        cmd  = "Mason",
        keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Abre Mason" } },
        build = ":MasonUpdate",  -- atualiza registry ao instalar
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
    -- MASON-LSPCONFIG (integra mason com lspconfig)
    -- =========================================================================
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            -- Servidores que instalam automaticamente:
            ensure_installed = {
                -- C / C++
                "clangd",
                -- Python
                "basedpyright",     -- fork melhorado do pyright
                -- Lua (pra editar a config do nvim)
                "lua_ls",
                -- Web
                "ts_ls",            -- TypeScript/JavaScript
                "html",
                "cssls",
                "jsonls",
                "yamlls",
                -- Bash/Shell
                "bashls",
                -- Kotlin (pra seus projetos Android)
                -- "kotlin_language_server",  -- pesado, comente se não usar
                -- Markdown
                "marksman",
            },
            automatic_installation = true,  -- instala automaticamente
        },
    },

    -- =========================================================================
    -- NVIM-LSPCONFIG (configura os servidores instalados)
    -- =========================================================================
    {
        "neovim/nvim-lspconfig",
        event        = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",      -- integração com autocomplete
            "b0o/SchemaStore.nvim",       -- schemas pra JSON/YAML
        },
        config = function()
            -- ---------------------------------------------------------------
            -- ATALHOS DE TECLADO DO LSP
            -- ---------------------------------------------------------------
            -- Esses atalhos só funcionam quando um LSP está ativo no buffer.
            local on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, {
                        buffer  = bufnr,
                        desc    = "LSP: " .. desc,
                        silent  = true,
                    })
                end

                -- Navegação
                map("gd",         vim.lsp.buf.definition,        "Ir pra definição")
                map("gD",         vim.lsp.buf.declaration,       "Ir pra declaração")
                map("gi",         vim.lsp.buf.implementation,    "Ir pra implementação")
                map("gt",         vim.lsp.buf.type_definition,   "Ir pro tipo")
                map("gr",         "<cmd>Telescope lsp_references<cr>", "Ver referências")

                -- Documentação
                map("K",          vim.lsp.buf.hover,             "Documentação (hover)")
                map("<C-k>",      vim.lsp.buf.signature_help,    "Ajuda de assinatura")

                -- Ações
                map("<leader>ca", vim.lsp.buf.code_action,       "Code action")
                map("<leader>rn", vim.lsp.buf.rename,            "Renomeia símbolo")
                map("<leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, "Formata arquivo")

                -- Diagnósticos (erros e avisos)
                map("[d",  vim.diagnostic.goto_prev,            "Erro anterior")
                map("]d",  vim.diagnostic.goto_next,            "Próximo erro")
                map("<leader>cd", vim.diagnostic.open_float,    "Ver erro (float)")
                map("<leader>cl", "<cmd>Telescope diagnostics<cr>", "Lista de erros")

                -- Workspace
                map("<leader>ws", vim.lsp.buf.workspace_symbol, "Busca símbolo no workspace")

                -- Destaque de referências
                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer   = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        buffer   = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end

            -- ---------------------------------------------------------------
            -- APARÊNCIA DOS DIAGNÓSTICOS
            -- ---------------------------------------------------------------
            vim.diagnostic.config({
                virtual_text = {
                    prefix  = "●",
                    spacing = 4,
                },
                signs       = true,
                underline   = true,
                update_in_insert = false,  -- não mostra erros enquanto digita
                severity_sort    = true,
                float = {
                    border = "rounded",
                    source = "always",
                },
            })

            -- Ícones na coluna de sinais
            local signs = {
                Error = " ",
                Warn  = " ",
                Hint  = "󰠠 ",
                Info  = " ",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- ---------------------------------------------------------------
            -- CAPACIDADES (capabilities)
            -- ---------------------------------------------------------------
            -- Diz pros LSPs quais features o cliente (nvim) suporta.
            -- cmp-nvim-lsp adiciona capacidades de autocompletar.
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly     = true,
            }

            -- ---------------------------------------------------------------
            -- CONFIGURAÇÃO DOS SERVIDORES
            -- ---------------------------------------------------------------
            local lspconfig = require("lspconfig")

            -- Helper pra configurar com defaults
            local function setup(server, opts)
                opts = vim.tbl_deep_extend("force", {
                    on_attach    = on_attach,
                    capabilities = capabilities,
                }, opts or {})
                lspconfig[server].setup(opts)
            end

            -- ---------------------------
            -- C / C++ (clangd)
            -- ---------------------------
            setup("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",         -- indexa em background
                    "--clang-tidy",               -- usa clang-tidy pra linting
                    "--header-insertion=iwyu",    -- include what you use
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir  = require("lspconfig.util").root_pattern(
                    "compile_commands.json", "compile_flags.txt",
                    "CMakeLists.txt", ".git"
                ),
                init_options = {
                    usePlaceholders    = true,
                    completeUnimported = true,
                    clangdFileStatus   = true,
                },
            })

            -- ---------------------------
            -- Python (basedpyright)
            -- ---------------------------
            setup("basedpyright", {
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths         = true,
                            diagnosticMode          = "workspace",
                            useLibraryCodeForTypes  = true,
                            typeCheckingMode        = "basic",
                        },
                    },
                },
            })

            -- ---------------------------
            -- Lua (pra editar o nvim)
            -- ---------------------------
            setup("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,  -- biblioteca do nvim
                                "${3rd}/luv/library",
                            },
                        },
                        completion = { callSnippet = "Replace" },
                        diagnostics = {
                            globals = { "vim" },  -- não reclama de 'vim' global
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- ---------------------------
            -- TypeScript / JavaScript
            -- ---------------------------
            setup("ts_ls", {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints    = "all",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints     = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints    = "all",
                        },
                    },
                },
            })

            -- ---------------------------
            -- HTML
            -- ---------------------------
            setup("html", {
                filetypes = { "html", "htmldjango" },
            })

            -- ---------------------------
            -- CSS
            -- ---------------------------
            setup("cssls")

            -- ---------------------------
            -- JSON (com schemas)
            -- ---------------------------
            setup("jsonls", {
                settings = {
                    json = {
                        schemas  = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

            -- ---------------------------
            -- YAML (com schemas)
            -- ---------------------------
            setup("yamlls", {
                settings = {
                    yaml = {
                        schemaStore  = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            })

            -- ---------------------------
            -- Bash
            -- ---------------------------
            setup("bashls")

            -- ---------------------------
            -- Markdown
            -- ---------------------------
            setup("marksman")

            -- ---------------------------
            -- Kotlin (descomente se usar)
            -- ---------------------------
            -- setup("kotlin_language_server")

        end,
    },

    -- =========================================================================
    -- CLANGD EXTENSIONS (extras pra C/C++)
    -- =========================================================================
    -- Adiciona: inlay hints, type hierarchy, memory usage view, etc.
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        opts = {
            ast = {
                role_icons = {
                    type = "",
                    declaration = "󰙞",
                    expression = "󰠲",
                    specifier = "󰦤",
                    statement = "󰅩",
                    ["template argument"] = "󰬛",
                },
            },
            memory_usage = { border = "rounded" },
        },
    },

    -- =========================================================================
    -- SCHEMASTORE (schemas pra JSON/YAML)
    -- =========================================================================
    -- Dá autocompletar em package.json, .eslintrc, docker-compose.yml, etc.
    { "b0o/SchemaStore.nvim", lazy = true },

    -- =========================================================================
    -- LSP SAGA (UI melhorada pra ações do LSP)
    -- =========================================================================
    -- Renomear, code actions, peek definition - tudo com UI mais bonita.
    {
        "nvimdev/lspsaga.nvim",
        event        = "LspAttach",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            ui = {
                border      = "rounded",
                devicon     = true,
            },
            lightbulb = {
                enable = true,       -- mostra 💡 quando há code actions
                sign   = true,
            },
            rename = {
                in_select = false,   -- não seleciona ao renomear
            },
        },
        keys = {
            { "gh",          "<cmd>Lspsaga hover_doc<cr>",        desc = "LSP: Hover doc (saga)" },
            { "<leader>ca",  "<cmd>Lspsaga code_action<cr>",      desc = "LSP: Code action (saga)" },
            { "<leader>rn",  "<cmd>Lspsaga rename<cr>",           desc = "LSP: Rename (saga)" },
            { "<leader>pd",  "<cmd>Lspsaga peek_definition<cr>",  desc = "LSP: Peek definition" },
            { "<leader>pt",  "<cmd>Lspsaga peek_type_definition<cr>", desc = "LSP: Peek type" },
            { "<leader>of",  "<cmd>Lspsaga outline<cr>",          desc = "LSP: Outline do arquivo" },
            { "[e",          "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Erro anterior" },
            { "]e",          "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Próximo erro" },
        },
    },

    -- =========================================================================
    -- TROUBLE (lista de erros / diagnósticos)
    -- =========================================================================
    -- Uma lista bonita de todos os erros, avisos e TODO do projeto.
    -- <leader>xx = abre/fecha
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd  = { "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnósticos (projeto)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnósticos (arquivo)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Símbolos" },
            { "<leader>xl", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix" },
        },
        opts = { use_diagnostic_signs = true },
    },

}
