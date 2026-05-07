-- =============================================================================
-- AUTOCOMPLETAR (lua/plugins/completion.lua)
-- =============================================================================
-- nvim-cmp é o sistema de autocompletar.
-- Ele coleta sugestões de várias fontes e mostra num menu.
--
-- Fontes usadas:
--   • nvim-lsp     = sugestões do Language Server (mais relevantes)
--   • luasnip      = snippets (templates de código)
--   • buffer       = palavras do arquivo atual
--   • path         = caminhos de arquivo
--   • cmdline      = completar na linha de comando do vim

return {

    -- =========================================================================
    -- LUASNIP (motor de snippets)
    -- =========================================================================
    {
        "L3MON4D3/LuaSnip",
        build        = "make install_jsregexp",  -- suporte a expressões regulares
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            -- friendly-snippets tem snippets prontos pra várias linguagens
            require("luasnip.loaders.from_vscode").lazy_load()

            local ls = require("luasnip")

            -- Tab navega pelos campos do snippet
            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                else
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
                        "n", false
                    )
                end
            end, { desc = "Snippet: expande ou vai pro próximo campo" })

            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { desc = "Snippet: campo anterior" })
        end,
    },

    -- Coleção de snippets prontos pra várias linguagens
    { "rafamadriz/friendly-snippets", lazy = true },

    -- =========================================================================
    -- NVIM-CMP (motor de autocompletar)
    -- =========================================================================
    {
        "hrsh7th/nvim-cmp",
        event        = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",      -- fonte: LSP
            "hrsh7th/cmp-buffer",        -- fonte: buffer atual
            "hrsh7th/cmp-path",          -- fonte: caminhos de arquivo
            "hrsh7th/cmp-cmdline",       -- fonte: linha de comando
            "saadparwaiz1/cmp_luasnip",  -- fonte: snippets
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",      -- ícones bonitos no menu
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                -- Usa LuaSnip como motor de snippets
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                -- Janela do menu
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                -- -------------------------------------------------------
                -- ATALHOS NO MENU DE AUTOCOMPLETE
                -- -------------------------------------------------------
                mapping = cmp.mapping.preset.insert({
                    -- Navegação no menu
                    ["<C-j>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<Down>"]  = cmp.mapping.select_next_item(),
                    ["<Up>"]    = cmp.mapping.select_prev_item(),

                    -- Scroll na documentação
                    ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]   = cmp.mapping.scroll_docs(4),

                    -- Abre/fecha menu manualmente
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]    = cmp.mapping.abort(),

                    -- Enter confirma a sugestão
                    ["<CR>"]    = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select   = true,  -- confirma mesmo sem selecionar
                    }),

                    -- Tab: confirma se menu aberto, vai pro snippet se disponível
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                -- -------------------------------------------------------
                -- FONTES DE SUGESTÃO (ordem = prioridade)
                -- -------------------------------------------------------
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },  -- LSP: mais relevante
                    { name = "luasnip",  priority = 750 },   -- snippets
                    { name = "buffer",   priority = 500,     -- palavras do buffer
                      option = {
                          get_bufnrs = function()
                              -- Considera todos os buffers abertos
                              return vim.api.nvim_list_bufs()
                          end,
                      }
                    },
                    { name = "path",     priority = 250 },   -- caminhos
                }),

                -- -------------------------------------------------------
                -- FORMATAÇÃO DO MENU
                -- -------------------------------------------------------
                formatting = {
                    expandable_indicator = true,
                    format = lspkind.cmp_format({
                        mode          = "symbol_text",  -- ícone + texto
                        maxwidth       = 50,
                        ellipsis_char  = "...",
                        show_labelDetails = true,
                        menu = {
                            nvim_lsp  = "[LSP]",
                            luasnip   = "[Snip]",
                            buffer    = "[Buf]",
                            path      = "[Path]",
                        },
                    }),
                },

                -- -------------------------------------------------------
                -- DESABILITA EM COMENTÁRIOS
                -- -------------------------------------------------------
                enabled = function()
                    -- Não mostra autocomplete em comentários
                    local context = require("cmp.config.context")
                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    else
                        return not context.in_treesitter_capture("comment")
                            and not context.in_syntax_group("Comment")
                    end
                end,

                -- Ordena: keyword_length primeiro, depois score do LSP
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            })

            -- -------------------------------------------------------
            -- AUTOCOMPLETE NA LINHA DE BUSCA (/)
            -- -------------------------------------------------------
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })

            -- -------------------------------------------------------
            -- AUTOCOMPLETE NA LINHA DE COMANDO (:)
            -- -------------------------------------------------------
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
    },

    -- =========================================================================
    -- LSPKIND (ícones no menu de autocomplete)
    -- =========================================================================
    { "onsails/lspkind.nvim", lazy = true },

    -- =========================================================================
    -- COPILOT (IA - sugestões de código)
    -- =========================================================================
    -- OPCIONAL: GitHub Copilot. Precisa de conta e autenticação (:Copilot auth).
    -- Comente o bloco abaixo se não quiser usar.
    -- {
    --     "zbirenbaum/copilot.nvim",
    --     event = "InsertEnter",
    --     opts = {
    --         suggestion = {
    --             enabled    = true,
    --             auto_trigger = true,
    --             keymap = {
    --                 accept = "<M-CR>",  -- Alt+Enter aceita sugestão
    --                 dismiss = "<C-]>",
    --             },
    --         },
    --         panel = { enabled = false },
    --         filetypes = {
    --             markdown = true,
    --             help     = false,
    --         },
    --     },
    -- },

}
