-- =============================================================================
-- TMUX (lua/plugins/tmux.lua)
-- =============================================================================
-- Integra a navegacao entre splits do NeoVim e paineis do tmux.
-- Requer tambem o plugin christoomey/vim-tmux-navigator no tmux.conf.

return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.g.tmux_navigator_save_on_switch = 2
        end,
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = { "n" }, desc = "Tmux/split esquerda" },
            { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  mode = { "n" }, desc = "Tmux/split baixo" },
            { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    mode = { "n" }, desc = "Tmux/split cima" },
            { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n" }, desc = "Tmux/split direita" },
        },
    },
}
