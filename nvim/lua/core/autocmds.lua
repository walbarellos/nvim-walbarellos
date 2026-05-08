-- =============================================================================
-- AUTOCMDS (lua/core/autocmds.lua)
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Destaca texto copiado por 150ms
autocmd("TextYankPost", {
    group    = augroup("YankHighlight", { clear = true }),
    pattern  = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Remove espaços no final das linhas ao salvar
autocmd("BufWritePre", {
    group    = augroup("TrimWhitespace", { clear = true }),
    pattern  = "*",
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- Volta pro último lugar ao reabrir arquivo
autocmd("BufReadPost", {
    group    = augroup("LastPosition", { clear = true }),
    pattern  = "*",
    callback = function()
        local mark   = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Configurações por tipo de arquivo
local ft = augroup("FileTypeSettings", { clear = true })

autocmd("FileType", {
    group   = ft,
    pattern = { "markdown", "txt", "gitcommit" },
    callback = function()
        vim.opt_local.wrap    = true
        vim.opt_local.spell   = true
        vim.opt_local.spelllang = "pt_br,en_us"
    end,
})

autocmd("FileType", {
    group   = ft,
    pattern = { "html", "css", "javascript", "typescript",
                "json", "yaml", "lua" },
    callback = function()
        vim.opt_local.tabstop   = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Portugol: detecta extensões e define filetype
autocmd({ "BufRead", "BufNewFile" }, {
    group   = augroup("PortugolDetect", { clear = true }),
    pattern = { "*.por", "*.portugol", "*.alg" },
    callback = function()
        vim.bo.filetype = "portugol"
    end,
})

-- Fecha janelas utilitárias com 'q'
autocmd("FileType", {
    group   = augroup("CloseWithQ", { clear = true }),
    pattern = { "help", "qf", "notify", "lspinfo", "checkhealth",
                "startuptime", "PlenaryTestPopup", "mason" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>",
            { buffer = event.buf, silent = true })
    end,
})

-- Recarrega arquivo se mudou externamente
autocmd({ "FocusGained", "BufEnter" }, {
    group    = augroup("AutoReload", { clear = true }),
    callback = function()
        if vim.fn.mode() ~= "c" then
            pcall(vim.cmd, "checktime")
        end
    end,
})
