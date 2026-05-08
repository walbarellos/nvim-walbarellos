-- =============================================================================
-- DEBUG (lua/plugins/debug.lua)
-- =============================================================================
-- DAP (Debug Adapter Protocol): breakpoints, step-over, variáveis, etc.
-- Funciona como o debugger do VSCode, mas dentro do nvim.
--
-- Atalhos:
--   <F5>         = inicia/continua debug
--   <F10>        = step over (próxima linha)
--   <F11>        = step into (entra na função)
--   <F12>        = step out (sai da função)
--   <leader>db   = toggle breakpoint
--   <leader>dB   = breakpoint condicional
--   <leader>du   = abre/fecha UI do debugger
--   <leader>dr   = REPL do debugger
--
-- Requer: instalar adapters via Mason
--   :Mason → busca "debugpy" (Python) ou "codelldb" (C/C++)

return {

    -- =========================================================================
    -- NVIM-DAP - core do debugger
    -- =========================================================================
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<F5>",        function() require("dap").continue() end,          desc = "Debug: Continua" },
            { "<F10>",       function() require("dap").step_over() end,         desc = "Debug: Step over" },
            { "<F11>",       function() require("dap").step_into() end,         desc = "Debug: Step into" },
            { "<F12>",       function() require("dap").step_out() end,          desc = "Debug: Step out" },
            { "<leader>db",  function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
            { "<leader>dB",  function()
                require("dap").set_breakpoint(vim.fn.input("Condição: "))
            end, desc = "Debug: Breakpoint condicional" },
            { "<leader>dr",  function() require("dap").repl.open() end,         desc = "Debug: REPL" },
            { "<leader>dl",  function() require("dap").run_last() end,          desc = "Debug: Roda último" },
            { "<leader>dx",  function() require("dap").terminate() end,         desc = "Debug: Para" },
        },
    },

    -- =========================================================================
    -- NVIM-DAP-UI - interface visual do debugger
    -- =========================================================================
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",  -- dependência necessária
        },
        keys = {
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: UI toggle" },
        },
        config = function()
            local dap    = require("dap")
            local dapui  = require("dapui")

            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        size     = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size     = 10,
                        position = "bottom",
                    },
                },
            })

            -- Abre/fecha UI automaticamente ao iniciar/parar debug
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    -- =========================================================================
    -- NVIM-DAP-PYTHON
    -- =========================================================================
    {
        "mfussenegger/nvim-dap-python",
        ft           = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            -- Usa o python do ambiente virtual se existir, senão usa o do sistema
            local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            require("dap-python").setup(python_path)
        end,
        keys = {
            { "<leader>dm", function() require("dap-python").test_method() end,  desc = "Debug: Testa método Python" },
            { "<leader>dc", function() require("dap-python").test_class() end,   desc = "Debug: Testa classe Python" },
        },
    },

    -- =========================================================================
    -- MASON-DAP - instala adapters de debug via Mason
    -- =========================================================================
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            -- Instala automaticamente:
            ensure_installed = {
                "debugpy",   -- Python
                "codelldb",  -- C/C++/Rust
            },
            automatic_installation = true,
        },
    },

    -- =========================================================================
    -- NIO (dependência do dapui)
    -- =========================================================================
    { "nvim-neotest/nvim-nio", lazy = true },

}
