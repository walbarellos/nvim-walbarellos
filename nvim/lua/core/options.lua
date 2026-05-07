-- =============================================================================
-- OPÇÕES DO EDITOR (lua/core/options.lua)
-- =============================================================================
-- Aqui ficam todas as configurações básicas do Neovim.
-- vim.opt.X = Y  →  equivalente ao  :set X=Y  no Vim clássico

local opt = vim.opt  -- atalho pra não ficar repetindo vim.opt

-- =============================================================================
-- APARÊNCIA
-- =============================================================================
opt.number         = true    -- mostra número das linhas
opt.relativenumber = true    -- número relativo (ótimo pra navegar: 5j, 3k)
opt.cursorline     = true    -- destaca a linha onde o cursor está
opt.signcolumn     = "yes"   -- coluna de sinais (erros, git) sempre visível
opt.colorcolumn    = "100"   -- linha vertical em 100 chars (limite de coluna)
opt.termguicolors  = true    -- cores RGB completas (necessário pro tema)
opt.showmode       = false   -- não mostra -- INSERT -- (a statusline já faz isso)
opt.cmdheight      = 1       -- altura da linha de comando
opt.pumheight      = 10      -- máximo de itens no menu de autocomplete
opt.conceallevel   = 0       -- não esconde syntax especial (ex: markdown)
opt.scrolloff      = 8       -- mantém 8 linhas de contexto acima/abaixo do cursor
opt.sidescrolloff  = 8       -- idem pro lado
opt.wrap           = false   -- não quebra linhas longas (scroll horizontal)
opt.linebreak      = true    -- se wrap estiver on, quebra em palavras inteiras

-- =============================================================================
-- INDENTAÇÃO
-- =============================================================================
opt.tabstop        = 4       -- tab = 4 espaços (visual)
opt.softtabstop    = 4       -- tab = 4 espaços (edição)
opt.shiftwidth     = 4       -- indentação automática = 4 espaços
opt.expandtab      = true    -- converte tab em espaços
opt.autoindent     = true    -- mantém indentação da linha anterior
opt.smartindent    = true    -- indentação inteligente pra código

-- NOTA: vim-sleuth (plugin) detecta a indentação de cada projeto
--       e sobrescreve essas configurações automaticamente.

-- =============================================================================
-- BUSCA
-- =============================================================================
opt.hlsearch       = true    -- destaca resultados de busca
opt.incsearch      = true    -- destaca enquanto digita
opt.ignorecase     = true    -- busca case-insensitive
opt.smartcase      = true    -- mas se tiver maiúscula, case-sensitive

-- =============================================================================
-- ARQUIVOS E BACKUP
-- =============================================================================
opt.swapfile       = false   -- sem arquivo .swp (irritante)
opt.backup         = false   -- sem backup (usamos git!)
opt.undofile       = true    -- desfazer persiste entre sessões!
opt.undodir        = vim.fn.stdpath("data") .. "/undodir"  -- onde salva

-- Garante que o diretório de undo existe
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undodir", "p")

-- =============================================================================
-- PERFORMANCE
-- =============================================================================
opt.updatetime     = 250     -- ms pra escrever no swap e disparar CursorHold
opt.timeoutlen     = 300     -- ms pra esperar próxima tecla de um atalho

-- =============================================================================
-- SPLITS E JANELAS
-- =============================================================================
opt.splitbelow     = true    -- :split abre abaixo (não acima)
opt.splitright     = true    -- :vsplit abre à direita (não à esquerda)

-- =============================================================================
-- CLIPBOARD
-- =============================================================================
-- Integra o clipboard do sistema com o Neovim.
-- Você pode copiar do Neovim e colar no browser, etc.
opt.clipboard      = "unnamedplus"

-- =============================================================================
-- WILDCARDS E COMPLETIONS
-- =============================================================================
opt.wildmode       = "longest:full,full"   -- modo de completar na linha de comando
opt.completeopt    = "menu,menuone,noselect"  -- comportamento do autocomplete

-- =============================================================================
-- CARACTERES ESPECIAIS
-- =============================================================================
opt.list           = true    -- mostra caracteres invisíveis
opt.listchars      = {
    tab      = "→ ",         -- tabulação aparece como →
    trail    = "·",          -- espaços no final da linha aparecem como ·
    nbsp     = "␣",          -- non-breaking space
}

-- =============================================================================
-- MOUSE
-- =============================================================================
opt.mouse          = "a"     -- habilita mouse em todos os modos
                             -- (útil pra clicar, selecionar, redimensionar)

-- =============================================================================
-- ENCODING
-- =============================================================================
opt.fileencoding   = "utf-8"  -- salva arquivos em UTF-8
vim.scriptencoding = "utf-8"

-- =============================================================================
-- FOLD (dobramento de código)
-- =============================================================================
-- Usa Treesitter pra detectar folds (melhor que indent ou syntax)
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99      -- começa com tudo expandido

-- =============================================================================
-- MISCELÂNEA
-- =============================================================================
opt.shortmess:append("c")   -- não mostra mensagens de completar (menos ruído)
opt.iskeyword:append("-")   -- trata palavra-com-traço como uma palavra só
opt.formatoptions:remove({ "c", "r", "o" })  -- não continua comentários com Enter
