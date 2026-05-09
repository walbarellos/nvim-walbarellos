-- =============================================================================
-- NABUR'S NEOVIM CONFIG - init.lua
-- =============================================================================
-- Ponto de entrada. Carrega core primeiro, depois plugins.
--
-- Estrutura:
--   init.lua                  ← você está aqui
--   lua/core/options.lua      ← configurações gerais do editor
--   lua/core/keymaps.lua      ← atalhos de teclado base
--   lua/core/autocmds.lua     ← comandos automáticos
--   lua/plugins/              ← um arquivo por grupo de plugins
-- =============================================================================

require("core.options")
require("core.keymaps")
require("core.autocmds")

-- =============================================================================
-- LAZY.NVIM - Gerenciador de plugins
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    ui = {
        border = "rounded",
        size   = { width = 0.9, height = 0.85 },
    },
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})

-- Keymaps extras: Kotlin, FastAPI, Docker e PostgreSQL
require("core.keymaps_extra")

-- Snippets locais em lua/snippets/*.lua
local ok_luasnip_loader, luasnip_loader = pcall(require, "luasnip.loaders.from_lua")
if ok_luasnip_loader then
    luasnip_loader.load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
end
