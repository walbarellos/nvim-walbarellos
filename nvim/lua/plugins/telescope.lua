-- =============================================================================
-- TELESCOPE (lua/plugins/telescope.lua)
-- =============================================================================
-- Fuzzy finder: busca arquivos, texto, git, LSP, etc.
-- É o plugin mais usado no dia a dia.
--
-- Atalhos principais:
--   <Space>ff = busca arquivo por nome
--   <Space>fg = busca texto no projeto (live grep)
--   <Space>fb = lista buffers abertos
--   <Space>fh = ajuda do vim
--   <Space>fr = arquivos recentes
--   <Space>fc = busca na config do nvim
--   <Space>fs = busca símbolo LSP
--   <Space>fd = diagnósticos (erros/avisos)
--   <Space>gf = arquivos modificados no git
--   <Space>gc = commits do git
--
-- Dentro do telescope:
--   <C-j> / <C-k>   = navega nos resultados
--   <C-x>           = abre em split horizontal
--   <C-v>           = abre em split vertical
--   <C-t>           = abre em nova tab
--   <Esc> ou <C-c>  = fecha

return {
    {
        "nvim-telescope/telescope.nvim",
        -- Carrega CEDO pra garantir que os comandos existem (inclusive pro alpha)
        event        = "VimEnter",
        version      = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Extension: fzf nativo em C (busca muito mais rápida)
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                -- Se 'make' falhar (sem gcc/cmake), carrega sem o fzf nativo
                cond  = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            -- Extension: navega entre arquivos recentes do projeto
            "nvim-telescope/telescope-file-browser.nvim",
            -- Extension: integração com ui-select (substitui vim.ui.select)
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")
            local builtin   = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    -- Aparência
                    prompt_prefix   = "  ",
                    selection_caret = "  ",
                    path_display    = { "smart" },  -- encurta caminhos longos
                    sorting_strategy = "ascending",
                    layout_config    = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width   = 0.55,
                            results_width   = 0.45,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width         = 0.87,
                        height        = 0.80,
                        preview_cutoff = 120,
                    },
                    -- Arquivos/pastas a ignorar na busca
                    file_ignore_patterns = {
                        "^.git/",
                        "^node_modules/",
                        "^.cache/",
                        "^build/",
                        "^dist/",
                        "^target/",  -- Rust
                        "%.o$",      -- objetos C
                        "%.class$",  -- Java
                        "%.pyc$",    -- Python
                    },
                    -- Atalhos dentro do telescope
                    mappings = {
                        i = {
                            ["<C-j>"]    = actions.move_selection_next,
                            ["<C-k>"]    = actions.move_selection_previous,
                            ["<C-x>"]    = actions.select_horizontal,
                            ["<C-v>"]    = actions.select_vertical,
                            ["<C-t>"]    = actions.select_tab,
                            ["<C-q>"]    = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-u>"]    = false,  -- limpa prompt (padrão)
                            ["<C-d>"]    = false,  -- scroll docs (padrão)
                            ["<Esc>"]    = actions.close,
                        },
                        n = {
                            ["q"]    = actions.close,
                            ["<Esc>"] = actions.close,
                        },
                    },
                },
                pickers = {
                    -- Configurações por picker
                    find_files = {
                        hidden       = true,       -- mostra arquivos ocultos
                        find_command = vim.fn.executable("fd") == 1
                            and { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
                            or  nil,  -- fallback pra find nativo
                    },
                    live_grep = {
                        additional_args = { "--hidden" },
                    },
                    oldfiles = {
                        cwd_only = true,  -- só do projeto atual
                    },
                    buffers = {
                        sort_mru     = true,
                        ignore_current_buffer = true,
                    },
                    diagnostics = {
                        theme = "ivy",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy            = true,
                        override_generic_sorter = true,
                        override_file_sorter    = true,
                        case_mode        = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            -- Carrega extensions
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "file_browser")
            pcall(telescope.load_extension, "ui-select")

            -- ---------------------------------------------------------------
            -- ATALHOS
            -- ---------------------------------------------------------------
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { desc = desc, silent = true })
            end

            -- Arquivos
            map("<leader>ff", builtin.find_files,   "Busca arquivo")
            map("<leader>fr", builtin.oldfiles,     "Arquivos recentes")
            map("<leader>fg", builtin.live_grep,    "Busca texto (grep)")
            map("<leader>fw", builtin.grep_string,  "Busca palavra sob cursor")
            map("<leader>fb", builtin.buffers,      "Lista buffers")
            map("<leader>fh", builtin.help_tags,    "Ajuda vim")
            map("<leader>fk", builtin.keymaps,      "Atalhos")
            map("<leader>fc", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, "Busca na config do nvim")

            -- Git
            map("<leader>gf", builtin.git_files,   "Arquivos git")
            map("<leader>gc", builtin.git_commits,  "Commits git")
            map("<leader>gb", builtin.git_branches, "Branches git")
            map("<leader>gs", builtin.git_status,   "Status git")

            -- LSP
            map("<leader>fs", builtin.lsp_document_symbols,   "Símbolos do arquivo")
            map("<leader>fS", builtin.lsp_workspace_symbols,  "Símbolos do workspace")
            map("<leader>fd", builtin.diagnostics,             "Diagnósticos")
            map("<leader>fi", builtin.lsp_implementations,    "Implementações")

            -- Misc
            map("<leader>fm", builtin.marks,        "Marks")
            map("<leader>fq", builtin.quickfix,     "Quickfix")
            map("<leader>f/", function()
                builtin.current_buffer_fuzzy_find(
                    require("telescope.themes").get_dropdown({ previewer = false })
                )
            end, "Busca no buffer atual")
        end,
    },
}
