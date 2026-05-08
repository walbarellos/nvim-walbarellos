-- =============================================================================
-- EDITOR (lua/plugins/editor.lua)
-- =============================================================================
-- Plugins que melhoram a experiência de edição:
--   • autopairs      - fecha () [] {} "" '' automaticamente
--   • surround       - adiciona/muda/remove () [] {} "" '' ao redor de texto
--   • comment        - comenta/descomenta código
--   • flash          - navegação relâmpago pela tela
--   • mini.ai        - text objects extras
--   • vim-sleuth     - detecta indentação do projeto
--   • substitute     - substitui texto com objeto de movimento
--   • spectre        - busca e substitui em múltiplos arquivos

return {

    -- =========================================================================
    -- AUTOPAIRS - fecha parênteses, colchetes, aspas automaticamente
    -- =========================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts  = {
            check_ts            = true,  -- usa treesitter pra ser mais inteligente
            ts_config           = {
                lua  = { "string" },
                javascript = { "template_string" },
            },
            fast_wrap           = {
                map  = "<M-e>",  -- Alt+e = fecha o par em redor da palavra
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                end_key = "$",
            },
        },
        config = function(_, opts)
            local autopairs = require("nvim-autopairs")
            autopairs.setup(opts)

            -- Integra com nvim-cmp: fecha pares ao confirmar no autocomplete
            local ok, cmp = pcall(require, "cmp")
            if ok then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        end,
    },

    -- =========================================================================
    -- SURROUND - manipula delimitadores ao redor de texto
    -- =========================================================================
    -- Exemplos:
    --   ys iw "   = adiciona " " ao redor da palavra
    --   ys iw (   = adiciona ( ) ao redor da palavra
    --   ds "      = remove as " " ao redor
    --   cs " '    = muda de " " pra ' '
    --   S " (visual mode) = adiciona " ao redor da seleção
    {
        "kylechui/nvim-surround",
        version = "*",
        event   = "BufReadPost",
        opts    = {},
    },

    -- =========================================================================
    -- COMMENT - comenta/descomenta código
    -- =========================================================================
    -- gcc = comenta/descomenta linha
    -- gc  = comenta/descomenta seleção (visual)
    -- gbc = comenta bloco (/* */ em C)
    {
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        opts  = {},
    },

    -- =========================================================================
    -- FLASH - navegação relâmpago
    -- =========================================================================
    -- s + duas letras = pula pra qualquer lugar visível na tela
    -- S = treesitter select (seleciona nó da AST)
    -- f/t/F/T melhorados com highlights
    {
        "folke/flash.nvim",
        event = "BufReadPost",
        opts  = {
            search = { mode = "fuzzy" },
            modes  = {
                search = { enabled = false },  -- não interfere com /busca
                char   = {
                    jump_labels = true,  -- mostra labels no f/t
                },
            },
        },
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash: pula" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash: treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Flash: remote" },
            { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Flash: toggle busca" },
        },
    },

    -- =========================================================================
    -- MINI.AI - text objects extras (vai além do a"/i")
    -- =========================================================================
    -- Adiciona text objects pra:
    --   aa/ia = argumentos de função
    --   af/if = funções
    --   ac/ic = classes
    --   at/it = tags HTML
    --   a,/i, = separadores (vírgula, ponto, etc.)
    {
        "echasnovski/mini.ai",
        version = "*",
        event   = "BufReadPost",
        opts    = {
            n_lines = 500,  -- procura em até 500 linhas
        },
    },

    -- =========================================================================
    -- MINI.PAIRS - alternativa leve ao autopairs (backup)
    -- Descomente se o nvim-autopairs der problema.
    -- =========================================================================
    -- { "echasnovski/mini.pairs", version = "*", event = "InsertEnter", opts = {} },

    -- =========================================================================
    -- VIM-SLEUTH - detecta indentação do projeto automaticamente
    -- =========================================================================
    -- Se o projeto usa 2 espaços, usa 2. Se usa tabs, usa tabs.
    -- Sobrescreve as opções de indentação do options.lua.
    { "tpope/vim-sleuth", event = "BufReadPost" },

    -- =========================================================================
    -- SPECTRE - busca e substitui em múltiplos arquivos
    -- =========================================================================
    -- Como o "Find & Replace" do VSCode.
    -- <Space>S = abre spectre
    -- <Space>sw = busca a palavra sob o cursor
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>S",  function() require("spectre").open() end,             desc = "Spectre (find & replace)" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,
              desc = "Spectre: palavra sob cursor" },
            { "<leader>sf", function() require("spectre").open_file_search() end, desc = "Spectre: no arquivo atual" },
        },
        opts = {},
    },

    -- =========================================================================
    -- BETTER ESCAPE - sai do insert mode com jk
    -- (sobrescreve o mapeamento básico do keymaps.lua com mais inteligência)
    -- =========================================================================
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        opts  = {
            timeout    = 300,
            default_mappings = true,
            mappings   = {
                i = { j = { k = "<Esc>" } },
                v = { j = { k = "<Esc>" } },
            },
        },
    },

    -- =========================================================================
    -- UNDOTREE - visualiza histórico de desfazer
    -- <Space>u = abre undotree
    -- =========================================================================
    {
        "mbbill/undotree",
        cmd  = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
        },
    },

    -- =========================================================================
    -- YANKY - histórico de clipboard
    -- =========================================================================
    -- p / P normal, mas pode navegar pelo histórico de cópias com <C-p>/<C-n>
    {
        "gbprod/yanky.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPost",
        opts  = {
            ring = { history_length = 100 },
            highlight = { timer = 150 },
        },
        keys = {
            { "p",     "<Plug>(YankyPutAfter)",        mode = { "n", "x" }, desc = "Cola depois" },
            { "P",     "<Plug>(YankyPutBefore)",       mode = { "n", "x" }, desc = "Cola antes" },
            { "gp",    "<Plug>(YankyGPutAfter)",       mode = { "n", "x" }, desc = "Cola (move cursor)" },
            { "gP",    "<Plug>(YankyGPutBefore)",      mode = { "n", "x" }, desc = "Cola antes (move cursor)" },
            { "<C-p>", "<Plug>(YankyCycleForward)",    desc = "Histórico clipboard (próximo)" },
            { "<C-n>", "<Plug>(YankyCycleBackward)",   desc = "Histórico clipboard (anterior)" },
        },
    },

}
