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

            -- Sai do modo terminal facilmente
            -- (Esc Esc volta pro modo normal dentro do terminal)
            vim.api.nvim_create_autocmd("TermOpen", {
                pattern  = "term://*toggleterm#*",
                callback = function()
                    map("t", "<Esc><Esc>", "<C-\\><C-n>",
                        { buffer = 0, desc = "Sai do modo terminal" })
                    map("t", "<C-h>", "<C-\\><C-n><C-w>h",
                        { buffer = 0, desc = "Terminal → split esquerda" })
                    map("t", "<C-l>", "<C-\\><C-n><C-w>l",
                        { buffer = 0, desc = "Terminal → split direita" })
                    map("t", "<C-j>", "<C-\\><C-n><C-w>j",
                        { buffer = 0, desc = "Terminal → split baixo" })
                    map("t", "<C-k>", "<C-\\><C-n><C-w>k",
                        { buffer = 0, desc = "Terminal → split cima" })
                end,
            })
        end,
    },

}
