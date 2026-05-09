-- lua/core/keymaps_extra.lua
-- Adiciona no final do keymaps.lua existente (ou cria e requer do init.lua)
--
-- Runner equivalente ao <Space>rr que existe para C,
-- mas para Kotlin standalone e FastAPI.

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- ════════════════════════════════════════════════════
-- Kotlin standalone (arquivo .kt fora de projeto Gradle)
-- ════════════════════════════════════════════════════
map("n", "<leader>kk", function()
    local file = vim.fn.expand("%:p")
    local name = vim.fn.expand("%:t:r")
    require("toggleterm.terminal").Terminal:new({
        cmd = "kotlinc " .. vim.fn.shellescape(file)
            .. " -include-runtime -d "
            .. vim.fn.shellescape("/tmp/" .. name .. ".jar")
            .. " && java -jar "
            .. vim.fn.shellescape("/tmp/" .. name .. ".jar"),
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "Kotlin: compila e roda arquivo atual")

map("n", "<leader>kg", function()
    -- Projeto Gradle: roda :run ou :test dependendo do contexto
    local has_gradle = vim.fn.findfile("gradlew", vim.fn.getcwd() .. ";") ~= ""
    local cmd = has_gradle and "./gradlew run" or "gradle run"
    require("toggleterm.terminal").Terminal:new({
        cmd = cmd,
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "Kotlin: Gradle run")

map("n", "<leader>kt", function()
    local has_gradle = vim.fn.findfile("gradlew", vim.fn.getcwd() .. ";") ~= ""
    local cmd = has_gradle and "./gradlew test" or "gradle test"
    require("toggleterm.terminal").Terminal:new({
        cmd = cmd,
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "Kotlin: Gradle test")

-- ════════════════════════════════════════════════════
-- FastAPI / Python backend
-- ════════════════════════════════════════════════════
map("n", "<leader>fa", function()
    -- Detecta se tem .venv e usa o uvicorn de lá
    local venv = vim.fn.getcwd() .. "/.venv/bin/uvicorn"
    local uvicorn = vim.fn.filereadable(venv) == 1 and venv or "uvicorn"
    require("toggleterm.terminal").Terminal:new({
        cmd = uvicorn .. " main:app --reload --host 0.0.0.0 --port 8000",
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "FastAPI: uvicorn main:app --reload")

map("n", "<leader>fp", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "python -m pytest -v",
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "FastAPI: pytest")

-- ════════════════════════════════════════════════════
-- Docker / Compose (projetos LicitaCidadão, Vigília)
-- ════════════════════════════════════════════════════
map("n", "<leader>Du", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "docker compose up",
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "Docker: compose up")

map("n", "<leader>Dd", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "docker compose down",
        direction = "float",
        close_on_exit = true,
    }):toggle()
end, "Docker: compose down")

map("n", "<leader>Dl", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "docker compose logs -f",
        direction = "horizontal",
        close_on_exit = false,
    }):toggle()
end, "Docker: compose logs -f")

-- ════════════════════════════════════════════════════
-- PostgreSQL rápido via psql
-- ════════════════════════════════════════════════════
map("n", "<leader>Dp", function()
    vim.ui.input({ prompt = "DB name (enter=postgres): " }, function(db)
        db = db ~= "" and db or "postgres"
        require("toggleterm.terminal").Terminal:new({
            cmd = "psql -U postgres -d " .. vim.fn.shellescape(db),
            direction = "float",
            close_on_exit = false,
        }):toggle()
    end)
end, "PostgreSQL: abre psql interativo")

-- ════════════════════════════════════════════════════
-- Atalhos no which-key (registro de grupos)
-- ════════════════════════════════════════════════════
local ok, wk = pcall(require, "which-key")
if ok then
    wk.add({
        { "<leader>k",  group = "kotlin" },
        { "<leader>D",  group = "database/docker" },
        { "<leader>fa", desc  = "FastAPI: uvicorn" },
        { "<leader>fp", desc  = "FastAPI: pytest" },
        { "<leader>Du", desc  = "Docker: up" },
        { "<leader>Dd", desc  = "Docker: down" },
        { "<leader>Dl", desc  = "Docker: logs" },
        { "<leader>Dp", desc  = "PostgreSQL: psql" },
    })
end
