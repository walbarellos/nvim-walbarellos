-- =============================================================================
-- PLUGINS DE INTERFACE (lua/plugins/ui.lua)
-- =============================================================================
-- Tudo que muda a APARÊNCIA do editor:
--   • Tema de cores (catppuccin)
--   • Statusline (lualine) - barra de baixo
--   • Bufferline - abas de arquivo no topo
--   • Explorador de arquivos (nvim-tree)
--   • Tela inicial (dashboard)
--   • which-key - mostra atalhos disponíveis
--   • Notificações bonitas (noice + notify)
--   • Guias de indentação
--   • Colorizer (mostra cores CSS)
--   • Ícones

return {

    -- =========================================================================
    -- ÍCONES (dependência de vários outros plugins)
    -- =========================================================================
    -- Ícones de arquivo (requer Nerd Font instalada no terminal).
    -- Baixe uma em: https://www.nerdfonts.com/
    -- Recomendo: JetBrainsMono Nerd Font ou FiraCode Nerd Font
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,  -- carrega só quando necessário
    },

    -- =========================================================================
    -- TEMA: CATPPUCCIN
    -- =========================================================================
    -- Um dos temas mais bonitos e bem mantidos. Tem 4 sabores:
    --   latte (claro), frappe, macchiato, mocha (escuro)
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,  -- carrega primeiro (antes de outros plugins de UI)
        opts = {
            flavour             = "mocha",       -- sabor: escuro
            background          = { light = "latte", dark = "mocha" },
            transparent_background = false,       -- mude pra true se quiser fundo transparente
            show_end_of_buffer  = true,           -- mostra ~ nas linhas vazias
            term_colors         = true,
            integrations = {
                -- Lista de plugins que o catppuccin estiliza:
                cmp             = true,
                gitsigns        = true,
                nvimtree        = true,
                treesitter      = true,
                telescope       = { enabled = true },
                which_key       = true,
                bufferline      = true,
                mason           = true,
                mini            = true,
                noice           = true,
                notify          = true,
                lsp_trouble     = true,
                indent_blankline = { enabled = true },
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors      = { "underline" },
                        hints       = { "underline" },
                        warnings    = { "underline" },
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
    -- A barra de status na parte de baixo do editor.
    -- Mostra: modo, arquivo, git branch, erros, posição do cursor, etc.
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme                = "catppuccin",
                globalstatus         = true,
                disabled_filetypes   = { statusline = { "dashboard", "alpha" } },
                component_separators = { left = "|", right = "|" },
                section_separators   = { left = "", right = "" },
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
    -- Mostra todos os arquivos abertos como abas no topo.
    -- Use Shift+l / Shift+h pra navegar.
    {
        "akinsho/bufferline.nvim",
        event        = "VeryLazy",
        version      = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                mode             = "buffers",
                separator_style  = "slant",
                show_buffer_close_icons = true,
                show_close_icon         = false,
                diagnostics             = "nvim_lsp",  -- mostra erros nas abas
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                offsets = {
                    {
                        filetype   = "NvimTree",
                        text       = "  Explorador",
                        highlight  = "Directory",
                        separator  = true,
                    },
                },
            },
        },
    },

    -- =========================================================================
    -- EXPLORADOR DE ARQUIVOS: NVIM-TREE
    -- =========================================================================
    -- Abre/fecha com <leader>e
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e",  "<cmd>NvimTreeToggle<cr>",   desc = "Explorador (toggle)" },
            { "<leader>E",  "<cmd>NvimTreeFocus<cr>",    desc = "Foca no explorador" },
            { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Acha arquivo atual no explorador" },
        },
        opts = {
            sort = { sorter = "case_sensitive" },
            view = {
                width         = 35,
                side          = "left",
                preserve_window_proportions = true,
            },
            renderer = {
                group_empty   = true,   -- agrupa pastas vazias
                highlight_git = true,   -- destaca arquivos com status git
                icons = {
                    show = {
                        git     = true,
                        file    = true,
                        folder  = true,
                    },
                },
            },
            filters = {
                dotfiles = false,       -- mostra arquivos ocultos (.)
            },
            git = { enable = true },
            actions = {
                open_file = {
                    quit_on_open = false,  -- não fecha ao abrir arquivo
                },
            },
        },
    },

    -- =========================================================================
    -- TELA INICIAL: DASHBOARD-NVIM (ALPHA)
    -- =========================================================================
    -- Tela bonita quando você abre o nvim sem arquivo.
    {
        "goolord/alpha-nvim",
        event        = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- Banner ASCII
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

            -- Botões do menu inicial
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Buscar arquivo",      ":Telescope find_files<CR>"),
                dashboard.button("r", "  Arquivos recentes",   ":Telescope oldfiles<CR>"),
                dashboard.button("g", "  Buscar texto",        ":Telescope live_grep<CR>"),
                dashboard.button("e", "  Explorador",          ":NvimTreeToggle<CR>"),
                dashboard.button("s", "  Restaurar sessão",    ":lua require('persistence').load()<CR>"),
                dashboard.button("c", "  Configuração",        ":e $MYVIMRC<CR>"),
                dashboard.button("u", "  Atualizar plugins",   ":Lazy update<CR>"),
                dashboard.button("q", "  Sair",                ":qa<CR>"),
            }

            -- Rodapé com plugins count
            local function footer()
                local stats = require("lazy").stats()
                return string.format(
                    "  %d plugins carregados em %.2fms",
                    stats.loaded, stats.startuptime
                )
            end

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "Comment"

            alpha.setup(dashboard.opts)
        end,
    },

    -- =========================================================================
    -- WHICH-KEY (dicionário de atalhos)
    -- =========================================================================
    -- Pressione <Space> e espere um segundo.
    -- Aparece uma janela mostrando TODOS os atalhos disponíveis.
    -- É impossível esquecer atalhos com esse plugin.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay   = 300,    -- ms pra aparecer
            plugins = {
                marks      = true,
                registers  = true,
                spelling   = { enabled = true, suggestions = 20 },
            },
            icons = {
                breadcrumb = "»",
                separator  = "→",
                group      = "+",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            -- Define grupos de atalhos (aparece como título no which-key)
            wk.add({
                { "<leader>b",  group = "Buffer" },
                { "<leader>c",  group = "Código / LSP" },
                { "<leader>d",  group = "Debug" },
                { "<leader>f",  group = "Buscar (Telescope)" },
                { "<leader>g",  group = "Git" },
                { "<leader>h",  group = "Hunk / Git hunk" },
                { "<leader>l",  group = "LSP" },
                { "<leader>r",  group = "Renomear / Replace" },
                { "<leader>s",  group = "Split" },
                { "<leader>t",  group = "Terminal" },
                { "<leader>x",  group = "Trouble / Diagnósticos" },
            })
        end,
    },

    -- =========================================================================
    -- NOICE (UI moderna pra mensagens, cmdline, notificações)
    -- =========================================================================
    -- Transforma a linha de comando e notificações em algo muito mais bonito.
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    -- Usa noice pra renderizar docs do LSP
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"]                = true,
                    ["cmp.entry.get_documentation"]                  = true,
                },
            },
            presets = {
                bottom_search         = true,   -- busca no rodapé
                command_palette       = true,   -- cmdline no centro
                long_message_to_split = true,   -- mensagens longas em split
                inc_rename            = false,
                lsp_doc_border        = true,   -- borda nas docs do LSP
            },
            routes = {
                -- Esconde mensagem chata "written" ao salvar
                {
                    filter = { event = "msg_show", find = "written" },
                    opts   = { skip = true },
                },
            },
        },
        keys = {
            { "<leader>nm", "<cmd>Noice<cr>",            desc = "Histórico de notificações" },
            { "<leader>nd", "<cmd>NoiceDismiss<cr>",     desc = "Descarta notificação" },
        },
    },

    -- =========================================================================
    -- GUIAS DE INDENTAÇÃO
    -- =========================================================================
    -- Linhas verticais mostrando os níveis de indentação.
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        main  = "ibl",
        opts  = {
            indent = {
                char      = "│",
                tab_char  = "│",
            },
            scope  = { enabled = true },
            exclude = {
                filetypes = { "help", "alpha", "dashboard", "NvimTree", "lazy", "mason" },
            },
        },
    },

    -- =========================================================================
    -- COLORIZER (mostra cores CSS inline)
    -- =========================================================================
    -- Quando você digita #ff5500 ou rgb(255, 0, 0), ele colore o fundo.
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        opts  = {
            filetypes = { "*" },
            user_default_options = {
                RGB           = true,
                RRGGBB        = true,
                names         = true,
                css           = true,
                css_fn        = true,
                mode          = "background",
                tailwind      = true,
                virtualtext   = "■",
            },
        },
    },

    -- =========================================================================
    -- TODO COMMENTS
    -- =========================================================================
    -- Destaca comentários TODO, FIXME, HACK, NOTE, WARN, etc.
    -- <leader>ft = busca todos os TODOs do projeto
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event        = "BufReadPost",
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Busca TODOs" },
            { "]t",  function() require("todo-comments").jump_next() end, desc = "Próximo TODO" },
            { "[t",  function() require("todo-comments").jump_prev() end, desc = "TODO anterior" },
        },
        opts = {
            signs = true,
            keywords = {
                FIX     = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO    = { icon = " ", color = "info" },
                HACK    = { icon = " ", color = "warning" },
                WARN    = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF    = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE    = { icon = "󰍨 ", color = "hint",    alt = { "INFO" } },
                TEST    = { icon = "⏲ ", color = "test",    alt = { "TESTING", "PASSED", "FAILED" } },
            },
        },
    },

    -- =========================================================================
    -- SMOOTH SCROLL
    -- =========================================================================
    -- Scroll suave (bonito, fácil de acompanhar).
    {
        "karb94/neoscroll.nvim",
        event = "BufReadPost",
        opts  = {
            easing_function = "quadratic",
        },
    },

    -- =========================================================================
    -- DRESSING (UI mais bonita pra inputs e selects)
    -- =========================================================================
    -- Quando o nvim pede um input ou opção, aparece uma janela bonitinha.
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts  = {},
    },

    -- =========================================================================
    -- ILLUMINATE (destaca outras ocorrências da palavra sob o cursor)
    -- =========================================================================
    -- Quando você parar sobre uma variável, todas as ocorrências ficam marcadas.
    {
        "RRethy/vim-illuminate",
        event    = "BufReadPost",
        opts = {
            delay            = 200,
            large_file_cutoff = 2000,
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
    },

    -- =========================================================================
    -- PERSISTENCE (sessões)
    -- =========================================================================
    -- Salva e restaura sessões automaticamente.
    -- Quando você abre nvim em um projeto, restaura os arquivos abertos.
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts  = { options = vim.opt.sessionoptions:get() },
        keys = {
            { "<leader>ss", function() require("persistence").load() end,                desc = "Restaura sessão" },
            { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Última sessão" },
            { "<leader>sd", function() require("persistence").stop() end,                desc = "Não salva sessão" },
        },
    },

}
