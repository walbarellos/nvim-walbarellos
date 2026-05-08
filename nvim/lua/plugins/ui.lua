-- =============================================================================
-- UI (lua/plugins/ui.lua)
-- =============================================================================

return {

    -- Ícones
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- =========================================================================
    -- TEMA: CATPPUCCIN
    -- =========================================================================
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false, -- Tema deve carregar IMEDIATAMENTE
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

    -- =========================================================================
    -- STATUSLINE: LUALINE
    -- =========================================================================
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
        opts = {
            options = {
                -- "auto" detecta o colorscheme atual (catppuccin)
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- =========================================================================
    -- BUFFERLINE
    -- =========================================================================
    {
        "akinsho/bufferline.nvim",
        event = "BufAdd",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                show_tab_indicators = true,
                always_show_bufferline = false,
            },
        },
    },

    -- =========================================================================
    -- EXPLORADOR DE ARQUIVOS: NVIM-TREE
    -- =========================================================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = {
            "NvimTreeToggle",
            "NvimTreeFocus",
            "NvimTreeFindFile",
            "NvimTreeOpen",
            "NvimTreeClose"
        },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorador" },
        },
        opts = {
            sort = { sorter = "case_sensitive" },
            view = { width = 35 },
            renderer = { highlight_git = true },
            git = { enable = true },
            actions = { open_file = { quit_on_open = false } },
        },
    },

    -- =========================================================================
    -- TELA INICIAL: ALPHA-NVIM
    -- =========================================================================
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗ █████╗ ██████╗ ██╗   ██╗██████╗       ",
                "  ████╗  ██║██╔══██╗██╔══██╗██║   ██║██╔══██╗      ",
                "  ██╔██╗ ██║███████║██████╔╝██║   ██║██████╔╝      ",
                "  ██║╚██╗██║██╔══██║██╔══██╗██║   ██║██╔══██╗      ",
                "  ██║ ╚████║██║  ██║██████╔╝╚██████╔╝██║  ██║      ",
                "  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝      ",
                "                                                     ",
            }
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Buscar arquivo",    "<cmd>Telescope find_files<cr>"),
                dashboard.button("r", "  Arquivos recentes", "<cmd>Telescope oldfiles<cr>"),
                dashboard.button("g", "  Buscar texto",      "<cmd>Telescope live_grep<cr>"),
                dashboard.button("e", "  Explorador",        "<cmd>NvimTreeToggle<cr>"),
                dashboard.button("s", "  Restaurar sessão",  "<cmd>lua require('persistence').load()<cr>"),
                dashboard.button("c", "  Configuração",      "<cmd>e $MYVIMRC<cr>"),
                dashboard.button("q", "  Sair",              "<cmd>qa<cr>"),
            }
            require("alpha").setup(dashboard.opts)
        end,
    },

    -- =========================================================================
    -- WHICH-KEY
    -- =========================================================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 300,
            icons = { breadcrumb = "»", separator = "→", group = "+" },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>f", group = "Busca (Telescope)" },
                { "<leader>c", group = "Código" },
                { "<leader>g", group = "Git" },
                { "<leader>x", group = "Erros" },
            })
        end,
    },

    -- =========================================================================
    -- NOICE + NOTIFY
    -- =========================================================================
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
            presets = {
                bottom_search = true,
                command_palette = true,
                lsp_doc_border = true,
            },
        },
    },

    -- =========================================================================
    -- OUTROS PLUGINS DE UI
    -- =========================================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        config = function()
            -- Lógica robusta para encontrar o módulo (v2 vs v3)
            local ok, ibl = pcall(require, "ibl")
            if ok then
                ibl.setup({ exclude = { filetypes = { "help", "alpha", "NvimTree" } } })
            else
                local ok2, indent_blankline = pcall(require, "indent_blankline")
                if ok2 then indent_blankline.setup({}) end
            end
        end,
    },

    { "NvChad/nvim-colorizer.lua", event = "BufReadPost", opts = { user_default_options = { tailwind = true } } },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = "BufReadPost", opts = {} },
    { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        opts = { delay = 200 },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
    },
    { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
    { "karb94/neoscroll.nvim", event = "BufReadPost", opts = { easing_function = "quadratic" } },
}
