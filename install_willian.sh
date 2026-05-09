#!/usr/bin/env bash
# install_willian.sh
# Roda DEPOIS do install.sh original do walbarellos.
# Instala as dependências extras para a stack: Kotlin, Docker, PostgreSQL, FastAPI.

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

info()  { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${RESET} $1"; }

# ─── Detecta gerenciador de pacotes ──────────────────────────────────────────
if   command -v apt-get &>/dev/null; then PM="apt-get"; INSTALL="sudo apt-get install -y"
elif command -v pacman  &>/dev/null; then PM="pacman";  INSTALL="sudo pacman -S --noconfirm"
elif command -v dnf     &>/dev/null; then PM="dnf";     INSTALL="sudo dnf install -y"
else warn "Gerenciador de pacotes não detectado. Instale manualmente."; fi

# ─── Kotlin (SDKMAN recomendado) ─────────────────────────────────────────────
if ! command -v kotlin &>/dev/null; then
    info "Instalando Kotlin via SDKMAN..."
    if ! command -v sdk &>/dev/null; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
    sdk install kotlin
    sdk install java 17.0.10-tem   # JDK 17 (Android target)
    info "Kotlin instalado: $(kotlin -version 2>&1)"
else
    info "Kotlin já instalado: $(kotlin -version 2>&1)"
fi

# ─── Docker ──────────────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    warn "Docker não encontrado. Instale manualmente em: https://docs.docker.com/engine/install/"
else
    info "Docker: $(docker --version)"
fi

if ! command -v docker-compose &>/dev/null && ! docker compose version &>/dev/null 2>&1; then
    warn "Docker Compose não encontrado."
else
    info "Docker Compose disponível."
fi

# ─── PostgreSQL client ───────────────────────────────────────────────────────
if ! command -v psql &>/dev/null; then
    info "Instalando postgresql-client..."
    if [ "$PM" = "apt-get" ]; then
        $INSTALL postgresql-client
    elif [ "$PM" = "pacman" ]; then
        $INSTALL postgresql-libs
    elif [ "$PM" = "dnf" ]; then
        $INSTALL postgresql
    fi
else
    info "psql: $(psql --version)"
fi

# ─── Python extras para FastAPI ──────────────────────────────────────────────
info "Instalando dependências Python para FastAPI..."
pip install --user uvicorn[standard] fastapi sqlalchemy alembic psycopg2-binary httpx pytest pytest-asyncio ruff black 2>/dev/null || \
    pip3 install --user uvicorn fastapi sqlalchemy alembic psycopg2-binary httpx pytest pytest-asyncio ruff black 2>/dev/null || \
    warn "pip falhou — ative um venv primeiro e rode: pip install uvicorn fastapi sqlalchemy alembic psycopg2-binary"

# ─── sqls (SQL language server) ──────────────────────────────────────────────
if ! command -v sqls &>/dev/null; then
    if command -v go &>/dev/null; then
        info "Instalando sqls via go..."
        go install github.com/sqls-server/sqls@latest
    else
        warn "Go não encontrado. sqls será instalado pelo Mason no Neovim (:Mason -> sqls)."
    fi
else
    info "sqls já instalado."
fi

# ─── ktlint (formatter Kotlin) ───────────────────────────────────────────────
KTLINT_BIN="$HOME/.local/bin/ktlint"
if [ ! -f "$KTLINT_BIN" ]; then
    info "Instalando ktlint..."
    mkdir -p "$HOME/.local/bin"
    curl -sSLO "https://github.com/pinterest/ktlint/releases/latest/download/ktlint"
    chmod +x ktlint
    mv ktlint "$KTLINT_BIN"
    info "ktlint instalado em $KTLINT_BIN"
else
    info "ktlint já instalado."
fi

# ─── Configura sqls para PostgreSQL ──────────────────────────────────────────
SQLS_CFG="$HOME/.config/sqls/config.yml"
if [ ! -f "$SQLS_CFG" ]; then
    mkdir -p "$(dirname "$SQLS_CFG")"
    cat > "$SQLS_CFG" << 'EOF'
# Configuração do sqls para PostgreSQL
# Edite com suas credenciais reais
connections:
  - driver: postgresql
    dataSourceName: 'host=localhost port=5432 user=postgres password=postgres dbname=postgres sslmode=disable'
  # Adicione outros bancos abaixo:
  # - driver: sqlite3
  #   dataSourceName: '/caminho/para/seu.db'
EOF
    warn "Criado $SQLS_CFG — edite com suas credenciais do PostgreSQL!"
else
    info "sqls config já existe: $SQLS_CFG"
fi

# ─── Copia arquivos de plugin para a config ativa do nvim ────────────────────
NVIM_PLUGINS="$HOME/.config/nvim/lua/plugins"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$NVIM_PLUGINS"

for f in kotlin.lua database.lua; do
    if [ -f "$SCRIPT_DIR/nvim/lua/plugins/$f" ]; then
        cp "$SCRIPT_DIR/nvim/lua/plugins/$f" "$NVIM_PLUGINS/$f"
        info "Copiado nvim/lua/plugins/$f para $NVIM_PLUGINS/"
    else
        warn "Arquivo nvim/lua/plugins/$f não encontrado no diretório do script."
    fi
done

NVIM_CORE="$HOME/.config/nvim/lua/core"
mkdir -p "$NVIM_CORE"
if [ -f "$SCRIPT_DIR/nvim/lua/core/keymaps_extra.lua" ]; then
    cp "$SCRIPT_DIR/nvim/lua/core/keymaps_extra.lua" "$NVIM_CORE/keymaps_extra.lua"
    info "Copiado keymaps_extra.lua para $NVIM_CORE/"

    # Adiciona require no final do init.lua se ainda não existir
    INIT_LUA="$HOME/.config/nvim/init.lua"
    if ! grep -q "keymaps_extra" "$INIT_LUA"; then
        echo '' >> "$INIT_LUA"
        echo '-- Keymaps extras: Kotlin, FastAPI, Docker e PostgreSQL' >> "$INIT_LUA"
        echo 'require("core.keymaps_extra")' >> "$INIT_LUA"
        info "Adicionado require('core.keymaps_extra') no init.lua"
    fi
fi

# ─── Instrução final ─────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════"
echo " NEOVIM"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Os LSPs extras já estão integrados no repo."
echo "Depois abra o Neovim e rode, se quiser forçar sincronização:"
echo "  :Lazy sync"
echo "  :Mason"
echo "  :checkhealth"
echo ""
info "Instalação extra concluída!"
