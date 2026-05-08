-- =============================================================================
-- NABUR'S NEOVIM CONFIG - init.lua
-- =============================================================================
-- Esse é o ponto de entrada. Ele apenas carrega os outros módulos.
-- Ordem importa: core primeiro, depois plugins.
--
-- Estrutura:
--   init.lua                  ← você está aqui
--   lua/core/options.lua      ← configurações gerais do editor
--   lua/core/keymaps.lua      ← atalhos de teclado base
--   lua/core/autocmds.lua     ← comandos automáticos (ex: formatar ao salvar)
--   lua/plugins/              ← cada arquivo = um grupo de plugins
-- =============================================================================

-- Carrega configurações base ANTES dos plugins
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- FIX: Compatibilidade entre Telescope e Treesitter v0.12+
-- O Telescope 0.1.x usa uma função que foi removida no Treesitter novo.
local ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if ts_utils then
    vim.treesitter.language.get_lang = vim.treesitter.language.get_lang or function(ft)
        return require("nvim-treesitter.parsers").ft_to_lang(ft)
    end
end

-- =============================================================================
-- LAZY.NVIM - Gerenciador de plugins
-- =============================================================================
-- lazy.nvim é o gerenciador de plugins mais moderno do Neovim.
-- Ele instala automaticamente na primeira vez que você abre o nvim.
-- Carrega plugins de forma "lazy" (sob demanda) pra inicialização rápida.

-- Caminho onde o lazy.nvim vai ser instalado
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Se ainda não instalado, clona do GitHub
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",  -- clone raso (mais rápido)
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",     -- usa branch estável
        lazypath,
    })
end

-- Adiciona lazy.nvim ao runtime path do Neovim
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- CARREGA TODOS OS PLUGINS
-- =============================================================================
-- O lazy.nvim vai ler todos os arquivos em lua/plugins/ automaticamente.
-- Cada arquivo retorna uma tabela com as configs dos plugins.

require("lazy").setup("plugins", {
    -- Configurações do gerenciador
    ui = {
        border = "rounded",      -- janela com bordas arredondadas
        size = { width = 0.9, height = 0.85 },
    },
    checker = {
        enabled = true,          -- checa updates de plugins automaticamente
        notify = false,          -- mas não enche o saco com notificações
    },
    change_detection = {
        notify = false,          -- não notifica quando config muda
    },
    performance = {
        rtp = {
            -- Desabilita plugins padrão desnecessários do Neovim
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",   -- substituído pelo nvim-tree
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
