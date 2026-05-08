-- =============================================================================
-- INTERFACE (lua/plugins/ui.lua)
-- =============================================================================

return {

    -- Ícones
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Tema Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                telescope = { enabled = true },
                which_key = true,
                bufferline = true,
                mason = true,
                noice = true,
                notify = true,
                lsp_trouble = true,
                indent_blankline = { enabled = true },
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Statusline Lualine
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme = "catppuccin",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
        },
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        version = "*",
        opts = {
            options = {
                mode = "buffers",
                separator_style = "slant",
                diagnostics = "nvim_lsp",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "Explorador",
                        highlight = "Directory",
                        separator = true,
                    },
                },
            },
        },
    },

    -- Nvim-Tree (Explorador)
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorador" },
        },
        opts = {
            sort = { sorter = "case_sensitive" },
            view = { width = 30, side = "left" },
            renderer = { highlight_git = true },
            git = { enable = true },
        },
    },

    -- Alpha (Dashboard)
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                "                                                     ",
            }
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Buscar arquivo",    ":Telescope find_files<CR>"),
                dashboard.button("r", "  Arquivos recentes", ":Telescope oldfiles<CR>"),
                dashboard.button("g", "  Buscar texto",      ":Telescope live_grep<CR>"),
                dashboard.button("e", "  Explorador",        ":NvimTreeToggle<CR>"),
                dashboard.button("c", "  Configuração",      ":e $MYVIMRC<CR>"),
                dashboard.button("q", "  Sair",              ":qa<CR>"),
            }
            require("alpha").setup(dashboard.opts)
        end,
    },

    -- Which-Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup()
            wk.add({
                { "<leader>f", group = "Busca (Telescope)" },
                { "<leader>c", group = "Código" },
                { "<leader>g", group = "Git" },
                { "<leader>x", group = "Erros" },
            })
        end,
    },

    -- Noice (Notificações)
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = { bottom_search = true, command_palette = true, lsp_doc_border = true },
        },
    },

    -- Indent Blankline
    { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost", main = "ibl", opts = {} },

    -- Colorizer
    { "NvChad/nvim-colorizer.lua", event = "BufReadPost", opts = { user_default_options = { tailwind = true } } },

    -- Todo Comments
    { "folke/todo-comments.nvim", event = "BufReadPost", opts = {} },

    -- Smooth Scroll
    { "karb94/neoscroll.nvim", event = "BufReadPost", opts = {} },

    -- Dressing
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Illuminate
    { "RRethy/vim-illuminate", event = "BufReadPost" },

    -- Persistence (Sessões)
    { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
}
