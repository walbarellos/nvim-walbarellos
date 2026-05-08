-- =============================================================================
-- UI (lua/plugins/ui.lua)
-- Tema, statusline, bufferline, explorador, tela inicial, atalhos visuais
-- =============================================================================
return {

    -- Ícones (requer Nerd Font: https://www.nerdfonts.com/)
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- =========================================================================
    -- TEMA: CATPPUCCIN MOCHA
    -- =========================================================================
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,
        opts = {
            flavour    = "mocha",
            integrations = {
                cmp              = true,
                gitsigns         = true,
                nvimtree         = true,
                treesitter       = true,
                telescope        = { enabled = true },
                which_key        = true,
                bufferline       = true,
                mason            = true,
                noice            = true,
                notify           = true,
                lsp_trouble      = true,
                indent_blankline = { enabled = true },
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors   = { "underline" },
                        warnings = { "underline" },
                        hints    = { "underline" },
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
        dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
        opts = {
            options = {
                theme = "catppuccin",
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
    -- BUFFERLINE (abas de arquivo no topo)
    -- =========================================================================
    {
        "akinsho/bufferline.nvim",
        event        = "BufAdd",
        version      = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                mode            = "buffers",
                separator_style = "slant",
                diagnostics     = "nvim_lsp",
                offsets = {
                    {
                        filetype  = "NvimTree",
                        text      = "  Explorador",
                        highlight = "Directory",
                        separator = true,
                    },
                },
                show_tab_indicators         = true,
                always_show_bufferline      = false,
            },
        },
    },

    -- =========================================================================
    -- EXPLORADOR DE ARQUIVOS: NVIM-TREE
    -- =========================================================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- Garante registro de comandos para o dashboard
        cmd = {
            "NvimTreeToggle",
            "NvimTreeFocus",
            "NvimTreeFindFile",
            "NvimTreeOpen",
            "NvimTreeClose"
        },
        keys = {
            { "<leader>e",  "<cmd>NvimTreeToggle<cr>",   desc = "Explorador (toggle)" },
            { "<leader>E",  "<cmd>NvimTreeFocus<cr>",    desc = "Foca no explorador" },
            { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Acha arquivo no explorador" },
        },
        opts = {
            sort      = { sorter = "case_sensitive" },
            view      = { width = 35 },
            renderer  = {
                group_empty   = true,
                highlight_git = true,
            },
            filters   = { dotfiles = false },
            git       = { enable = true },
            actions   = { open_file = { quit_on_open = false } },
        },
    },

    -- =========================================================================
    -- TELA INICIAL: ALPHA-NVIM
    -- =========================================================================
    {
        "goolord/alpha-nvim",
        event        = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha     = require("alpha")
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

            -- Rodapé seguro
            local stats_ok, lazy = pcall(require, "lazy")
            if stats_ok then
                local stats = lazy.stats()
                dashboard.section.footer.val = string.format(
                    "  %d plugins • %.2fms", stats.loaded, stats.startuptime
                )
            end

            dashboard.section.footer.opts.hl = "Comment"
            alpha.setup(dashboard.opts)
        end,
    },

    -- =========================================================================
    -- WHICH-KEY
    -- =========================================================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts  = {
            delay   = 300,
            plugins = { marks = true, registers = true },
            icons   = { breadcrumb = "»", separator = "→", group = "+" },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>b",  group = "Buffer" },
                { "<leader>c",  group = "Código / LSP" },
                { "<leader>d",  group = "Debug" },
                { "<leader>f",  group = "Buscar (Telescope)" },
                { "<leader>g",  group = "Git" },
                { "<leader>h",  group = "Git hunks" },
                { "<leader>l",  group = "LSP" },
                { "<leader>n",  group = "Notificações" },
                { "<leader>r",  group = "Renomear" },
                { "<leader>s",  group = "Split / Sessão" },
                { "<leader>t",  group = "Terminal / Toggle" },
                { "<leader>x",  group = "Trouble / Erros" },
            })
        end,
    },

    -- = :Notificações (Noice)
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"]                = true,
                    ["cmp.entry.get_documentation"]                  = true,
                },
            },
            presets = {
                bottom_search         = true,
                command_palette       = true,
                lsp_doc_border        = true,
            },
        },
        keys = {
            { "<leader>nm", "<cmd>Noice<cr>",        desc = "Histórico notificações" },
            { "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Descarta notificação" },
        },
    },

    -- Utilitários de UI
    { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost", main = "ibl", opts = {} },
    { "NvChad/nvim-colorizer.lua", event = "BufReadPost", opts = { user_default_options = { tailwind = true } } },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = "BufReadPost", opts = {} },
    { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },
    { "RRethy/vim-illuminate", event = "BufReadPost", opts = { delay = 200 } },
    { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
    { "karb94/neoscroll.nvim", event = "BufReadPost", opts = { easing_function = "quadratic" } },
}
