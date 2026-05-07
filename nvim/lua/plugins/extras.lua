-- =============================================================================
-- UPGRADES DE ELITE (lua/plugins/extras.lua)
-- =============================================================================

return {

    -- =========================================================================
    -- GITSIGNS (Git na linha)
    -- =========================================================================
    -- Mostra + e - no canto da tela indicando mudanças no Git.
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts  = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = " " },
                topdelete    = { text = "▔" },
                changedelete = { text = "▎" },
                untracked    = { text = "┆" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- Navegação entre mudanças
                map("n", "]h", gs.next_hunk, "Próxima mudança (Git)")
                map("n", "[h", gs.prev_hunk, "Mudança anterior (Git)")

                -- Ações
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
            end,
        },
    },

    -- =========================================================================
    -- AUTOPAIRS (Fecha parênteses/aspas sozinho)
    -- =========================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts  = {
            check_ts = true,  -- usa treesitter pra ser mais inteligente
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
        },
    },

    -- =========================================================================
    -- FLASH (Teletransporte do cursor)
    -- =========================================================================
    -- Aperte 's' e digite 2 letras para pular em qualquer lugar da tela.
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts  = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

}
