-- =============================================================================
-- COMANDOS AUTOMÁTICOS (lua/core/autocmds.lua)
-- =============================================================================
-- autocmds = comandos que rodam automaticamente em certos eventos.
-- Exemplos: "quando abrir Python, faça X"; "quando salvar, formate"

local augroup = vim.api.nvim_create_augroup  -- cria grupo de autocmds
local autocmd = vim.api.nvim_create_autocmd  -- cria autocmd

-- =============================================================================
-- DESTAQUE DE YANK (copiar)
-- =============================================================================
-- Quando você copia texto (yank), ele pisca brevemente pra confirmar.
-- Muito útil, evita copiar errado sem perceber.
local yank_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group    = yank_group,
    pattern  = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 150,  -- pisca por 150ms
        })
    end,
})

-- =============================================================================
-- REMOVE ESPAÇOS EM BRANCO NO FINAL DAS LINHAS
-- =============================================================================
-- Antes de salvar, remove trailing whitespace automaticamente.
local whitespace_group = augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
    group    = whitespace_group,
    pattern  = "*",
    callback = function()
        -- Salva posição do cursor
        local pos = vim.api.nvim_win_get_cursor(0)
        -- Remove espaços no final das linhas
        vim.cmd([[%s/\s\+$//e]])
        -- Restaura posição do cursor
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- =============================================================================
-- VOLTA PRO ÚLTIMO LUGAR NO ARQUIVO
-- =============================================================================
-- Quando você reabre um arquivo, o cursor vai pro lugar onde você estava.
local last_pos_group = augroup("LastPosition", { clear = true })
autocmd("BufReadPost", {
    group    = last_pos_group,
    pattern  = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- =============================================================================
-- CONFIGURAÇÕES POR TIPO DE ARQUIVO
-- =============================================================================
local filetype_group = augroup("FileTypeSettings", { clear = true })

-- Arquivos de texto e documentação: wrap e spell check
autocmd("FileType", {
    group   = filetype_group,
    pattern = { "markdown", "txt", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap    = true
        vim.opt_local.spell   = true
        vim.opt_local.spelllang = "pt_br,en_us"
    end,
})

-- Python: indentação 4 espaços (PEP 8)
autocmd("FileType", {
    group   = filetype_group,
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop     = 4
        vim.opt_local.shiftwidth  = 4
        vim.opt_local.expandtab   = true
    end,
})

-- C/C++: indentação 4 espaços
autocmd("FileType", {
    group   = filetype_group,
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.tabstop    = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab  = true
        -- Comentários de linha com //
        vim.opt_local.commentstring = "// %s"
    end,
})

-- Portugol: indentação 2 espaços (convenção)
autocmd("FileType", {
    group   = filetype_group,
    pattern = { "portugol", "por" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab  = true
    end,
})

-- Web (HTML, CSS, JS, TS): indentação 2 espaços (convenção web)
autocmd("FileType", {
    group   = filetype_group,
    pattern = { "html", "css", "javascript", "typescript", "json", "yaml" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab  = true
    end,
})

-- =============================================================================
-- FECHA ALGUMAS JANELAS COM 'q'
-- =============================================================================
-- Janelas de help, quickfix, etc. fecham com 'q' sem precisar de :q
local close_with_q = augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
    group   = close_with_q,
    pattern = { "help", "qf", "notify", "lspinfo", "checkhealth",
                "startuptime", "tsplayground", "PlenaryTestPopup" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>",
            { buffer = event.buf, silent = true })
    end,
})

-- =============================================================================
-- AUTO-RELOAD SE ARQUIVO MUDOU EXTERNAMENTE
-- =============================================================================
-- Se você editou o arquivo fora do nvim (ex: git pull), ele recarrega.
local reload_group = augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group    = reload_group,
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

-- =============================================================================
-- DETECÇÃO DE TIPO DE ARQUIVO PORTUGOL
-- =============================================================================
-- O Neovim não conhece Portugol nativamente. Ensinamos ele aqui.
autocmd({ "BufRead", "BufNewFile" }, {
    group   = augroup("PortugolDetect", { clear = true }),
    pattern = { "*.por", "*.portugol", "*.alg" },
    callback = function()
        vim.bo.filetype = "portugol"
    end,
})
