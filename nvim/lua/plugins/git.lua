-- =============================================================================
-- GIT (lua/plugins/git.lua)
-- =============================================================================
-- Integração completa com git dentro do nvim.
--
-- gitsigns: sinais na gutter (coluna da esquerda) mostrando mudanças
-- lazygit:  UI completa pro git (como GitKraken dentro do nvim)
-- diffview: visualiza diffs e histórico de arquivos

return {

    -- =========================================================================
    -- GITSIGNS - sinais de git na gutter
    -- =========================================================================
    -- Mostra linhas adicionadas (+), modificadas (~) e removidas (-).
    -- Navega entre hunks (blocos de mudança) com ]h e [h.
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        opts  = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },
            current_line_blame = true,   -- mostra "quem escreveu essa linha" no inline
            current_line_blame_opts = {
                delay        = 300,
                virt_text_pos = "eol",
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, keys, func, desc)
                    vim.keymap.set(mode, keys, func, {
                        buffer = bufnr, desc = "Git: " .. desc, silent = true
                    })
                end

                -- Navega entre hunks
                map("n", "]h", function()
                    if vim.wo.diff then return "]h" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, "Próximo hunk")

                map("n", "[h", function()
                    if vim.wo.diff then return "[h" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, "Hunk anterior")

                -- Ações de hunk
                map("n", "<leader>hs", gs.stage_hunk,  "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk,  "Reset hunk")
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk (seleção)")
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk (seleção)")

                map("n", "<leader>hS", gs.stage_buffer,   "Stage arquivo todo")
                map("n", "<leader>hR", gs.reset_buffer,   "Reset arquivo todo")
                map("n", "<leader>hu", gs.undo_stage_hunk,"Undo stage hunk")
                map("n", "<leader>hp", gs.preview_hunk,   "Preview hunk")
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame linha")
                map("n", "<leader>hd", gs.diffthis,       "Diff arquivo")
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, "Diff arquivo (HEAD~1)")
                map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame inline")

                -- Text object: ih = inner hunk
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Seleciona hunk")
            end,
        },
    },

    -- =========================================================================
    -- LAZYGIT - UI completa pra git
    -- <Space>lg = abre lazygit
    -- =========================================================================
    -- Requer lazygit instalado no sistema.
    -- Arch: sudo pacman -S lazygit
    -- Ubuntu: veja o install.sh
    -- Fedora: sudo dnf install lazygit
    {
        "kdheepak/lazygit.nvim",
        cmd          = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    -- =========================================================================
    -- DIFFVIEW - visualiza diffs e histórico
    -- <Space>gd = abre diff do arquivo atual
    -- <Space>gh = histórico do arquivo
    -- =========================================================================
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>",           desc = "Diff do projeto" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",  desc = "Histórico do arquivo" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",    desc = "Histórico do projeto" },
            { "<leader>gx", "<cmd>DiffviewClose<cr>",          desc = "Fecha diffview" },
        },
        opts = {},
    },

}
