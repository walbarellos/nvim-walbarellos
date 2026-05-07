-- =============================================================================
-- LSP (Language Server Protocol) (lua/plugins/lsp.lua)
-- =============================================================================

return {

    -- =========================================================================
    -- MASON (instalador de LSPs, formatters, linters)
    -- =========================================================================
    {
        "williamboman/mason.nvim",
        cmd  = "Mason",
        keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Abre Mason" } },
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
    -- MASON-LSPCONFIG
    -- =========================================================================
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "clangd",
                "basedpyright",
                "lua_ls",
                "ts_ls",
                "html",
                "cssls",
                "jsonls",
                "yamlls",
                "bashls",
                "marksman",
            },
            automatic_installation = true,
        },
    },

    -- =========================================================================
    -- NVIM-LSPCONFIG
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
            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")

            -- Configuração global de diagnósticos
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 4 },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = "always" },
            })

            -- Ícones nos diagnósticos
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Atalhos ao anexar LSP
            local on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                map("gd",         vim.lsp.buf.definition,        "Ir pra definição")
                map("gD",         vim.lsp.buf.declaration,       "Ir pra declaração")
                map("gi",         vim.lsp.buf.implementation,    "Ir pra implementação")
                map("gt",         vim.lsp.buf.type_definition,   "Ir pro tipo")
                map("gr",         "<cmd>Telescope lsp_references<cr>", "Ver referências")
                map("K",          vim.lsp.buf.hover,             "Documentação (hover)")
                map("<C-k>",      vim.lsp.buf.signature_help,    "Ajuda de assinatura")
                map("<leader>ca", vim.lsp.buf.code_action,       "Code action")
                map("<leader>rn", vim.lsp.buf.rename,            "Renomeia símbolo")
                map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Formata arquivo")
                map("[d",         vim.diagnostic.goto_prev,      "Erro anterior")
                map("]d",         vim.diagnostic.goto_next,      "Próximo erro")
                map("<leader>cd", vim.diagnostic.open_float,    "Ver erro (float)")
                map("<leader>cl", "<cmd>Telescope diagnostics<cr>", "Lista de erros")

                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end

            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            -- Configuração padrão para os servidores
            local function setup(server, opts)
                opts = vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }, opts or {})
                lspconfig[server].setup(opts)
            end

            -- Ativação dos servidores
            setup("clangd")
            setup("basedpyright")
            setup("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
            setup("ts_ls")
            setup("html")
            setup("cssls")
            setup("jsonls", { settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } })
            setup("yamlls", { settings = { yaml = { schemas = require("schemastore").yaml.schemas() } } })
            setup("bashls")
            setup("marksman")
        end,
    },

    -- =========================================================================
    -- CLANGD EXTENSIONS
    -- =========================================================================
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        opts = { memory_usage = { border = "rounded" } },
    },

    -- =========================================================================
    -- SCHEMASTORE
    -- =========================================================================
    { "b0o/SchemaStore.nvim", lazy = true },

    -- =========================================================================
    -- LSP SAGA
    -- =========================================================================
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = { ui = { border = "rounded" }, lightbulb = { enable = true } },
        keys = {
            { "gh",          "<cmd>Lspsaga hover_doc<cr>",        desc = "LSP: Hover doc" },
            { "<leader>ca",  "<cmd>Lspsaga code_action<cr>",      desc = "LSP: Code action" },
            { "<leader>rn",  "<cmd>Lspsaga rename<cr>",           desc = "LSP: Rename" },
            { "<leader>pd",  "<cmd>Lspsaga peek_definition<cr>",  desc = "LSP: Peek definition" },
            { "<leader>pt",  "<cmd>Lspsaga peek_type_definition<cr>", desc = "LSP: Peek type" },
            { "<leader>of",  "<cmd>Lspsaga outline<cr>",          desc = "LSP: Outline" },
        },
    },

    -- =========================================================================
    -- TROUBLE
    -- =========================================================================
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd  = { "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnósticos (projeto)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnósticos (arquivo)" },
        },
        opts = { use_diagnostic_signs = true },
    },
}
