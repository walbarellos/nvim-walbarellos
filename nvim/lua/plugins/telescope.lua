-- =============================================================================
-- TELESCOPE (lua/plugins/telescope.lua)
-- =============================================================================

return {
    {
        "nvim-telescope/telescope.nvim",
        -- Força carregamento na VimEnter para estar disponível no Dashboard
        event = "VimEnter",
        cmd = { "Telescope" },
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable("make") == 1 end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55 },
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<Esc>"] = actions.close,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                },
            })

            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "ui-select")
        end,
    },
}
