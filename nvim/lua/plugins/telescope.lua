-- =============================================================================
-- TELESCOPE (lua/plugins/telescope.lua)
-- =============================================================================

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Busca arquivos" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Busca texto" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Arquivos recentes" },
        },
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = { horizontal = { prompt_position = "top" } },
                    mappings = { i = { ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous } },
                },
            }
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("fzf")
        end,
    },
}
