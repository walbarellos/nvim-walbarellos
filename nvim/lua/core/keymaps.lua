-- =============================================================================
-- ATALHOS DE TECLADO (lua/core/keymaps.lua)
-- =============================================================================
-- LEADER KEY = <Space>
-- A maioria dos atalhos começa com <Space> seguido de outra tecla.
-- Pressione <Space>? pra ver TODOS os atalhos disponíveis (which-key).
--
-- Notação:
--   <leader>  = Space
--   <C-x>     = Ctrl + x
--   <M-x>     = Alt + x
--   <S-x>     = Shift + x
--   n         = normal mode
--   i         = insert mode
--   v         = visual mode
--   x         = visual + select mode
--   t         = terminal mode

vim.g.mapleader      = " "   -- <Space> como leader
vim.g.maplocalleader = " "

-- Helper pra não repetir opts toda hora
local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false  -- silencioso por padrão
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- =============================================================================
-- NAVEGAÇÃO BÁSICA
-- =============================================================================

-- Centraliza a tela ao navegar (fica mais fácil de acompanhar)
map("n", "<C-d>", "<C-d>zz", { desc = "Desce meia tela (centraliza)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Sobe meia tela (centraliza)" })
map("n", "n",     "nzzzv",   { desc = "Próximo resultado de busca (centraliza)" })
map("n", "N",     "Nzzzv",   { desc = "Resultado anterior de busca (centraliza)" })

-- Navega entre splits com Ctrl+hjkl (mais natural)
map("n", "<C-h>", "<C-w>h", { desc = "Vai pro split da esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Vai pro split de baixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Vai pro split de cima" })
map("n", "<C-l>", "<C-w>l", { desc = "Vai pro split da direita" })

-- Redimensiona splits com Ctrl+setas
map("n", "<C-Up>",    ":resize -2<CR>",          { desc = "Diminui altura do split" })
map("n", "<C-Down>",  ":resize +2<CR>",          { desc = "Aumenta altura do split" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Diminui largura do split" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Aumenta largura do split" })

-- =============================================================================
-- BUFFERS (arquivos abertos)
-- =============================================================================
-- Buffer = arquivo aberto na memória. Tabs = buffers visíveis na bufferline.
map("n", "<S-l>",      ":bnext<CR>",     { desc = "Próximo buffer" })
map("n", "<S-h>",      ":bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", ":bdelete<CR>",   { desc = "Fechar buffer atual" })
map("n", "<leader>bD", ":bdelete!<CR>",  { desc = "Fechar buffer (força)" })

-- =============================================================================
-- EDIÇÃO
-- =============================================================================

-- Move linhas selecionadas pra cima/baixo no visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move seleção pra baixo" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move seleção pra cima" })

-- Cola sem perder o que está no clipboard
-- (por padrão, deletar em visual mode sobrescreve o clipboard)
map("x", "<leader>p", '"_dP', { desc = "Cola sem perder clipboard" })

-- Copia pro clipboard do sistema explicitamente
map({ "n", "v" }, "<leader>y", '"+y',  { desc = "Copia pro clipboard do sistema" })
map("n",          "<leader>Y", '"+Y',  { desc = "Copia linha pro clipboard do sistema" })

-- Deleta sem afetar clipboard
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Deleta sem afetar clipboard" })

-- Indenta no visual mode sem perder a seleção
map("v", "<", "<gv", { desc = "Desindenta (mantém seleção)" })
map("v", ">", ">gv", { desc = "Indenta (mantém seleção)" })

-- Substitui a palavra sob o cursor em todo arquivo (rename rápido)
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "Renomeia palavra sob cursor no arquivo" })

-- =============================================================================
-- BUSCA
-- =============================================================================
-- Limpa destaque de busca com Escape
map("n", "<Esc>", ":nohl<CR>", { desc = "Limpa destaque de busca" })

-- =============================================================================
-- ARQUIVO E SESSÃO
-- =============================================================================
map("n", "<leader>w", ":w<CR>",  { desc = "Salva arquivo" })
map("n", "<leader>q", ":q<CR>",  { desc = "Fecha janela" })
map("n", "<leader>Q", ":qa!<CR>",{ desc = "Fecha tudo (força)" })

-- Abre config rapidinho
map("n", "<leader>,", ":e $MYVIMRC<CR>", { desc = "Abre init.lua" })

-- =============================================================================
-- SPLITS
-- =============================================================================
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", ":split<CR>",  { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=",      { desc = "Equaliza splits" })
map("n", "<leader>sx", ":close<CR>",  { desc = "Fecha split atual" })

-- =============================================================================
-- TERMINAL (toggleterm plugin vai sobrescrever, mas esses são fallbacks)
-- =============================================================================
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sai do modo terminal" })

-- =============================================================================
-- MODO INSERT - conforto
-- =============================================================================
-- jk = Esc no insert mode (muito mais rápido que ir até Esc)
map("i", "jk", "<Esc>", { desc = "Esc (jk)" })
map("i", "kj", "<Esc>", { desc = "Esc (kj)" })

-- Ctrl+s salva em insert mode também
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Salva (insert mode)" })

-- =============================================================================
-- LAZY E MASON (gerenciadores)
-- =============================================================================
map("n", "<leader>L",  ":Lazy<CR>",        { desc = "Abre Lazy (gerenciador plugins)" })
map("n", "<leader>M",  ":Mason<CR>",       { desc = "Abre Mason (gerenciador LSPs)" })
map("n", "<leader>Lu", ":Lazy update<CR>", { desc = "Atualiza plugins" })
