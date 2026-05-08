-- =============================================================================
-- TREESITTER (lua/plugins/treesitter.lua)
-- =============================================================================
-- Motor de sintaxe que "entende" seu código de verdade.
-- Fornece: highlight, fold, seleção inteligente, text objects.
--
-- NOTA: nvim-treesitter v1.x mudou a API.
--   Não usa mais: require("nvim-treesitter.configs").setup()
--   Agora usa:    main = "nvim-treesitter"  (lazy faz o setup direto)

return {

    -- =========================================================================
    -- NVIM-TREESITTER
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        version      = false,         -- usa commit mais recente
        build        = ":TSUpdate",   -- atualiza parsers ao instalar/atualizar
        event        = { "BufReadPost", "BufNewFile" },
        main         = "nvim-treesitter",   -- lazy chama nvim-treesitter.setup(opts)
        dependencies = {
            -- Text objects: selecionar funções, parâmetros, etc.
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            -- Highlight baseado em AST (muito melhor que regex)
            highlight = {
                enable  = true,
                -- Desabilita em arquivos muito grandes (>100KB) pra não travar
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > max_filesize
                end,
            },

            -- Indentação baseada em treesitter
            indent = { enable = true },

            -- Parsers instalados automaticamente
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "html",
                "css",
                "javascript",
                "typescript",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "query",     -- treesitter query language
                "regex",
                "vim",
                "vimdoc",
                "yaml",
                "toml",
                "gitignore",
                "gitcommit",
                "diff",
                "kotlin",    -- pra seus projetos Android
                "java",      -- Android também
                "sql",
                "xml",
            },

            -- Seleção incremental com Ctrl+Space
            -- Expande a seleção pro próximo nó da AST a cada aperto
            incremental_selection = {
                enable  = true,
                keymaps = {
                    init_selection    = "<C-space>",
                    node_incremental  = "<C-space>",
                    scope_incremental = false,
                    node_decremental  = "<bs>",
                },
            },

            -- Text objects: af = a function, if = inner function, etc.
            textobjects = {
                select = {
                    enable    = true,
                    lookahead = true,   -- pula pro próximo se não estiver em cima
                    keymaps   = {
                        ["af"] = { query = "@function.outer", desc = "Seleciona função inteira" },
                        ["if"] = { query = "@function.inner", desc = "Seleciona corpo da função" },
                        ["ac"] = { query = "@class.outer",    desc = "Seleciona classe inteira" },
                        ["ic"] = { query = "@class.inner",    desc = "Seleciona corpo da classe" },
                        ["aa"] = { query = "@parameter.outer", desc = "Seleciona parâmetro" },
                        ["ia"] = { query = "@parameter.inner", desc = "Seleciona valor do parâmetro" },
                        ["ai"] = { query = "@conditional.outer", desc = "Seleciona if/else inteiro" },
                        ["ii"] = { query = "@conditional.inner", desc = "Seleciona corpo do if" },
                        ["al"] = { query = "@loop.outer", desc = "Seleciona loop inteiro" },
                        ["il"] = { query = "@loop.inner", desc = "Seleciona corpo do loop" },
                    },
                },
                move = {
                    enable              = true,
                    set_jumps           = true,
                    goto_next_start     = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end       = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end   = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next     = { ["<leader>a"] = "@parameter.inner" },
                    swap_previous = { ["<leader>A"] = "@parameter.inner" },
                },
            },
        },
    },

    -- =========================================================================
    -- NVIM-TREESITTER-CONTEXT
    -- Mostra em qual função/classe você está quando scrolla pra baixo
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        opts  = {
            enable            = true,
            max_lines         = 3,
            min_window_height = 20,
            mode              = "cursor",
        },
        keys = {
            { "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle contexto treesitter" },
        },
    },

}
