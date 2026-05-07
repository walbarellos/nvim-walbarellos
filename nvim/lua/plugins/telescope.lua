-- =============================================================================
-- TELESCOPE (lua/plugins/telescope.lua)
-- =============================================================================
-- O buscador mais poderoso do universo Neovim.
-- Permite achar arquivos, textos, TODOs e muito mais com interface visual.

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
            "folke/todo-comments.nvim",
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Busca arquivos" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Busca texto (grep)" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Arquivos recentes" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers abertos" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Tags de ajuda" },
        },
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("fzf")
        end,
    },
}
