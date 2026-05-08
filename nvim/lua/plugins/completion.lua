-- =============================================================================
-- AUTOCOMPLETE (lua/plugins/completion.lua)
-- =============================================================================
-- nvim-cmp coleta sugestões de múltiplas fontes e exibe num menu.
-- LuaSnip fornece snippets (templates de código).
--
-- Atalhos no menu:
--   <C-j> / <C-k> = navega
--   <Tab>          = confirma / vai pro campo do snippet
--   <CR> (Enter)   = confirma
--   <C-e>          = fecha menu
--   <C-b> / <C-f>  = scroll na documentação

return {

    -- Motor de snippets
    {
        "L3MON4D3/LuaSnip",
        build        = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Snippets prontos pra várias linguagens (Python, C, C++, JS, etc.)
    { "rafamadriz/friendly-snippets", lazy = true },

    -- =========================================================================
    -- NVIM-CMP
    -- =========================================================================
    {
        "hrsh7th/nvim-cmp",
        event        = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"]     = cmp.mapping.select_next_item(),
                    ["<C-k>"]     = cmp.mapping.select_prev_item(),
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
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
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                    { name = "buffer",   priority = 500 },
                    { name = "path",     priority = 250 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode     = "symbol_text",
                        maxwidth = 50,
                        menu = {
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Buf]",
                            path     = "[Path]",
                        },
                    }),
                },
            })

            -- Autocomplete na busca (/)
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })

            -- Autocomplete na linha de comando (:)
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
    },

    { "onsails/lspkind.nvim", lazy = true },
}
