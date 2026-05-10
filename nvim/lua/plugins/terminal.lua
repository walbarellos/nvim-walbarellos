-- =============================================================================
-- TERMINAL (lua/plugins/terminal.lua)
-- =============================================================================
-- Terminais flutuantes e integrados dentro do nvim.
--
-- Atalhos:
--   <C-\>         = terminal flutuante (toggle)
--   <Space>th     = terminal horizontal
--   <Space>tv     = terminal vertical
--   <Space>tn     = novo terminal
--   <Space>rr     = compila e roda arquivo C atual
--   <Space>rc     = compila arquivo C atual
--   <Space>rg     = debug com gdb
--   <Space>rv     = valgrind
--   <Esc><Esc>    = sai do modo terminal (volta pro modo normal)

return {

    -- =========================================================================
    -- TOGGLETERM
    -- =========================================================================
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys    = {
            { "<C-\\>",     desc = "Terminal flutuante" },
            { "<leader>th", desc = "Terminal horizontal" },
            { "<leader>tv", desc = "Terminal vertical" },
            { "<leader>tn", desc = "Novo terminal" },
            { "<leader>rr", desc = "C: compila e roda" },
            { "<leader>rc", desc = "C: compila" },
            { "<leader>rg", desc = "C: gdb" },
            { "<leader>rv", desc = "C: valgrind" },
            { "<leader>lg", desc = "LazyGit (toggleterm)" },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                end
            end,
            open_mapping     = [[<C-\>]],    -- Ctrl+\ abre/fecha terminal flutuante
            hide_numbers     = true,
            shade_terminals  = true,
            start_in_insert  = true,
            insert_mappings  = true,
            terminal_mappings = true,
            persist_size     = true,
            persist_mode     = true,          -- mantém modo (insert/normal)
            direction        = "float",        -- padrão: flutuante
            close_on_exit    = true,
            shell            = vim.o.shell,
            auto_scroll      = true,
            float_opts = {
                border   = "curved",
                width    = math.floor(vim.o.columns * 0.85),
                height   = math.floor(vim.o.lines * 0.75),
                winblend = 0,
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            local Terminal = require("toggleterm.terminal").Terminal
            local map      = vim.keymap.set

            local function shell_quote(value)
                return vim.fn.shellescape(value)
            end

            local function current_c_target()
                local file = vim.api.nvim_buf_get_name(0)
                if file == "" then
                    vim.notify("Salve o arquivo antes de compilar.", vim.log.levels.WARN)
                    return nil
                end

                if vim.bo.filetype ~= "c" and not file:match("%.c$") then
                    vim.notify("Este atalho é para arquivos C (.c).", vim.log.levels.WARN)
                    return nil
                end

                vim.cmd.write()

                local dir = vim.fn.fnamemodify(file, ":h")
                local name = vim.fn.fnamemodify(file, ":t:r")

                return {
                    dir = dir,
                    src = vim.fn.fnamemodify(file, ":t"),
                    exe = name,
                }
            end

            local function run_c_command(command_builder)
                local target = current_c_target()
                if not target then return end

                local command = "cd " .. shell_quote(target.dir) .. " && " .. command_builder(target)
                local t = Terminal:new({
                    cmd = command,
                    direction = "horizontal",
                    close_on_exit = false,
                    hidden = true,
                })
                t:toggle()
            end

            -- Terminal horizontal (na parte de baixo)
            map("n", "<leader>th", function()
                local t = Terminal:new({ direction = "horizontal" })
                t:toggle()
            end, { desc = "Terminal horizontal" })

            -- Terminal vertical (na lateral)
            map("n", "<leader>tv", function()
                local t = Terminal:new({ direction = "vertical" })
                t:toggle()
            end, { desc = "Terminal vertical" })

            -- Novo terminal numerado
            map("n", "<leader>tn", function()
                local n = vim.v.count1
                local t = Terminal:new({ count = n })
                t:toggle()
            end, { desc = "Terminal N (count)" })

            map("n", "<leader>rc", function()
                run_c_command(function(target)
                    return table.concat({
                        "gcc",
                        shell_quote(target.src),
                        "-Wall",
                        "-Wextra",
                        "-std=c11",
                        "-g",
                        "-o",
                        shell_quote(target.exe),
                    }, " ")
                end)
            end, { desc = "C: compila arquivo atual" })

            map("n", "<leader>rr", function()
                run_c_command(function(target)
                    return table.concat({
                        "gcc",
                        shell_quote(target.src),
                        "-Wall",
                        "-Wextra",
                        "-std=c11",
                        "-g",
                        "-o",
                        shell_quote(target.exe),
                        "&&",
                        "./" .. shell_quote(target.exe),
                    }, " ")
                end)
            end, { desc = "C: compila e roda arquivo atual" })

            map("n", "<leader>rg", function()
                run_c_command(function(target)
                    return table.concat({
                        "gcc",
                        shell_quote(target.src),
                        "-Wall",
                        "-Wextra",
                        "-std=c11",
                        "-g",
                        "-o",
                        shell_quote(target.exe),
                        "&&",
                        "gdb",
                        "./" .. shell_quote(target.exe),
                    }, " ")
                end)
            end, { desc = "C: compila e abre gdb" })

            map("n", "<leader>rv", function()
                run_c_command(function(target)
                    return table.concat({
                        "gcc",
                        shell_quote(target.src),
                        "-Wall",
                        "-Wextra",
                        "-std=c11",
                        "-g",
                        "-o",
                        shell_quote(target.exe),
                        "&&",
                        "valgrind",
                        "--leak-check=full",
                        "./" .. shell_quote(target.exe),
                    }, " ")
                end)
            end, { desc = "C: compila e roda valgrind" })

            -- Sai do modo terminal facilmente
            -- (Esc Esc volta pro modo normal dentro do terminal)
            vim.api.nvim_create_autocmd("TermOpen", {
                pattern  = "term://*toggleterm#*",
                callback = function()
                    map("t", "<Esc><Esc>", "<C-\\><C-n>",
                        { buffer = 0, desc = "Sai do modo terminal" })
                    map("t", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>",
                        { buffer = 0, desc = "Terminal -> tmux/split esquerda" })
                    map("t", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>",
                        { buffer = 0, desc = "Terminal -> tmux/split direita" })
                    map("t", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>",
                        { buffer = 0, desc = "Terminal -> tmux/split baixo" })
                    map("t", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>",
                        { buffer = 0, desc = "Terminal -> tmux/split cima" })
                end,
            })
        end,
    },

}
