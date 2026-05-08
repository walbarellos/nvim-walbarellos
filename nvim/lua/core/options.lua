-- =============================================================================
-- OPÇÕES DO EDITOR (lua/core/options.lua)
-- =============================================================================
local opt = vim.opt

-- Aparência
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.colorcolumn    = "100"
opt.termguicolors  = true
opt.showmode       = false
opt.cmdheight      = 1
opt.pumheight      = 10
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false

-- Indentação
opt.tabstop        = 4
opt.softtabstop    = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.autoindent     = true
opt.smartindent    = true

-- Busca
opt.hlsearch       = true
opt.incsearch      = true
opt.ignorecase     = true
opt.smartcase      = true

-- Arquivos
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true
opt.undodir        = vim.fn.stdpath("data") .. "/undodir"
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undodir", "p")

-- Performance
opt.updatetime     = 250
opt.timeoutlen     = 300

-- Splits
opt.splitbelow     = true
opt.splitright     = true

-- Clipboard do sistema
opt.clipboard      = "unnamedplus"

-- Completar
opt.completeopt    = "menu,menuone,noselect"

-- Caracteres invisíveis
opt.list           = true
opt.listchars      = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Mouse
opt.mouse          = "a"

-- Encoding
opt.fileencoding   = "utf-8"
vim.scriptencoding = "utf-8"

-- Fold via treesitter (começa tudo expandido)
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel      = 99

-- Misc
opt.shortmess:append("c")
opt.iskeyword:append("-")
opt.formatoptions:remove({ "c", "r", "o" })
