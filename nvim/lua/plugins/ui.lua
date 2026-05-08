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

    -- =========================================================================
    -- STATUSLINE: LUALINE
    -- Barra de baixo: modo, branch, erros, arquivo, posição
    -- =========================================================================
    {
        "nvim-lualine/lualine.nvim",
        event        = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
        opts = {
            options = {
                theme              = "catppuccin",
                globalstatus       = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                -- Evita aviso sobre component_separators/section_separators
                component_separators = { left = "|", right = "|" },
                section_separators   = { left = "",  right = "" },
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
    -- Shift+l = próximo | Shift+h = anterior
    -- =========================================================================
    {
        "akinsho/bufferline.nvim",
        event        = "BufAdd",   -- só carrega quando abrir um buffer (evita E85)
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
                -- Não mostra bufferline com 1 ou 0 buffers
                show_tab_indicators         = true,
                always_show_bufferline      = false,
            },
        },
    },

    -- =========================================================================
    -- EXPLORADOR DE ARQUIVOS: NVIM-TREE
    -- <Space>e = abre/fecha
    -- =========================================================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- cmd garante que :NvimTreeToggle funciona (ex: botão do dashboard)
        -- sem cmd, o lazy só carrega via keys, e comandos diretos falham
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeOpen" },
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
    -- Aparece quando você abre nvim sem arquivo
    -- =========================================================================
    {
        "goolord/alpha-nvim",
        event        = "VimEnter",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            -- Telescope e NvimTree precisam estar disponíveis antes do alpha
            -- Isso é garantido pelo lazy carregando na VimEnter
        },
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
                dashboard.button("f", "  Buscar arquivo",
                    "<cmd>Telescope find_files<cr>"),
                dashboard.button("r", "  Arquivos recentes",
                    "<cmd>Telescope oldfiles<cr>"),
                dashboard.button("g", "  Buscar texto",
                    "<cmd>Telescope live_grep<cr>"),
                dashboard.button("e", "  Explorador",
                    "<cmd>NvimTreeToggle<cr>"),
                dashboard.button("s", "  Restaurar sessão",
                    "<cmd>lua require('persistence').load()<cr>"),
                dashboard.button("l", "  Plugins (Lazy)",
                    "<cmd>Lazy<cr>"),
                dashboard.button("c", "  Configuração",
                    "<cmd>e $MYVIMRC<cr>"),
                dashboard.button("q", "  Sair", "<cmd>qa<cr>"),
            }

            -- Carrega alpha sem rodapé de stats pra evitar erro no primeiro boot
            -- (lazy.stats pode não estar pronto ainda na VimEnter)
            local ok, lazy = pcall(require, "lazy")
            if ok then
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
    -- WHICH-KEY - mostra atalhos disponíveis
    -- Pressione <Space> e espere 300ms
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

            -- which-key v3: grupos são registrados via add() com spec de grupo
            -- O campo "group" define o título que aparece no popup
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

    -- =========================================================================
    -- NOICE + NOTIFY - notificações e cmdline modernos
    -- =========================================================================
    {
        "rcarriga/nvim-notify",
        lazy = true,
        opts = {
            timeout  = 3000,
            max_width = 60,
            render   = "compact",
            stages   = "fade_in_slide_out",
        },
    },
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
                long_message_to_split = true,
                lsp_doc_border        = true,
            },
            routes = {
                { filter = { event = "msg_show", find = "written" },   opts = { skip = true } },
                { filter = { event = "msg_show", find = "yanked" },    opts = { skip = true } },
                { filter = { event = "msg_show", find = "%d+ lines" }, opts = { skip = true } },
            },
        },
        keys = {
            { "<leader>nm", "<cmd>Noice<cr>",        desc = "Histórico notificações" },
            { "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Descarta notificação" },
        },
    },

    -- =========================================================================
    -- GUIAS DE INDENTAÇÃO
    -- =========================================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        main  = "ibl",
        opts  = {
            indent  = { char = "│" },
            scope   = { enabled = true },
            exclude = {
                filetypes = { "help", "alpha", "NvimTree", "lazy", "mason" },
            },
        },
    },

    -- =========================================================================
    -- COLORIZER - mostra cores CSS inline (#ff5500, rgb(...))
    -- =========================================================================
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        opts  = {
            filetypes            = { "*" },
            user_default_options = {
                RGB    = true,
                RRGGBB = true,
                css    = true,
                mode   = "background",
            },
        },
    },

    -- =========================================================================
    -- TODO-COMMENTS - destaca TODO, FIXME, NOTE, HACK, WARN
    -- =========================================================================
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event        = "BufReadPost",
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Busca TODOs" },
            { "]t", function() require("todo-comments").jump_next() end, desc = "Próximo TODO" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "TODO anterior" },
        },
        opts = {},
    },

    -- =========================================================================
    -- DRESSING - inputs e selects mais bonitos
    -- =========================================================================
    { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },

    -- =========================================================================
    -- ILLUMINATE - destaca outras ocorrências da palavra sob o cursor
    -- =========================================================================
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        opts  = { delay = 200 },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
    },

    -- =========================================================================
    -- PERSISTENCE - salva e restaura sessões
    -- <Space>ss = restaura sessão do projeto atual
    -- =========================================================================
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts  = {},
        keys = {
            { "<leader>ss", function() require("persistence").load() end,                desc = "Restaura sessão" },
            { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Última sessão" },
            { "<leader>sd", function() require("persistence").stop() end,                desc = "Não salva sessão" },
        },
    },

    -- =========================================================================
    -- NEOSCROLL - scroll suave
    -- =========================================================================
    {
        "karb94/neoscroll.nvim",
        event = "BufReadPost",
        opts  = { easing_function = "quadratic" },
    },

}
