-- =============================================================================
-- ATALHOS DE TECLADO (lua/core/keymaps.lua)
-- =============================================================================
-- LEADER = <Space>
-- Pressione <Space>? pra ver todos os atalhos (which-key)

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Navegação (centraliza tela)
map("n", "<C-d>", "<C-d>zz",  { desc = "Desce meia tela" })
map("n", "<C-u>", "<C-u>zz",  { desc = "Sobe meia tela" })
map("n", "n",     "nzzzv",    { desc = "Próximo resultado busca" })
map("n", "N",     "Nzzzv",    { desc = "Resultado anterior busca" })

-- Navega entre splits
map("n", "<C-h>", "<C-w>h", { desc = "Split esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Split baixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Split cima" })
map("n", "<C-l>", "<C-w>l", { desc = "Split direita" })

-- Redimensiona splits
map("n", "<C-Up>",    ":resize -2<CR>",          { desc = "Diminui altura" })
map("n", "<C-Down>",  ":resize +2<CR>",          { desc = "Aumenta altura" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Diminui largura" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Aumenta largura" })

-- Buffers
map("n", "<S-l>",      ":bnext<CR>",     { desc = "Próximo buffer" })
map("n", "<S-h>",      ":bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", ":bdelete<CR>",   { desc = "Fecha buffer" })
map("n", "<leader>bD", ":bdelete!<CR>",  { desc = "Fecha buffer (força)" })

-- Edição
map("v", "<A-j>", ":m '>+1<CR>gv=gv",  { desc = "Move seleção baixo" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv",  { desc = "Move seleção cima" })
map("x", "<leader>p", '"_dP',           { desc = "Cola sem perder clipboard" })
map({ "n", "v" }, "<leader>y", '"+y',   { desc = "Copia pro sistema" })
map("n",          "<leader>Y", '"+Y',   { desc = "Copia linha pro sistema" })
map({ "n", "v" }, "<leader>d", '"_d',   { desc = "Deleta sem clipboard" })
map("v", "<", "<gv",                    { desc = "Desindenta" })
map("v", ">", ">gv",                    { desc = "Indenta" })

-- Renomeia palavra no arquivo inteiro
map("n", "<leader>rw",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "Renomeia palavra no arquivo" })

-- Busca
map("n", "<Esc>", ":nohl<CR>", { desc = "Limpa destaque busca" })

-- Arquivo
map("n", "<leader>w",  ":w<CR>",    { desc = "Salva" })
map("n", "<leader>q",  ":q<CR>",    { desc = "Fecha janela" })
map("n", "<leader>Q",  ":qa!<CR>",  { desc = "Fecha tudo" })
map("n", "<leader>,",  ":e $MYVIMRC<CR>", { desc = "Abre init.lua" })

-- Splits
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", ":split<CR>",  { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=",      { desc = "Equaliza splits" })
map("n", "<leader>sx", ":close<CR>",  { desc = "Fecha split" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sai do terminal" })

-- Insert mode
map("i", "jk", "<Esc>", { desc = "Esc" })
map("i", "kj", "<Esc>", { desc = "Esc" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Salva (insert)" })

-- Gerenciadores
map("n", "<leader>L",  ":Lazy<CR>",        { desc = "Lazy (plugins)" })
map("n", "<leader>M",  ":Mason<CR>",        { desc = "Mason (LSPs)" })
map("n", "<leader>Lu", ":Lazy update<CR>",  { desc = "Atualiza plugins" })
