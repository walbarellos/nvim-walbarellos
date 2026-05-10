#!/usr/bin/env bash
# install-elite.sh
# Instala e integra ferramentas de nível profissional: Yazi e GDB Dashboard.
# Suporta Arch/EndeavourOS e Ubuntu/Debian.

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

info()  { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${RESET} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }

# ─── Detecta Gerenciador de Pacotes ──────────────────────────────────────────
if command -v pacman >/dev/null 2>&1; then
    PM="pacman"
    INSTALL="sudo pacman -S --needed --noconfirm"
    DEPS="ffmpegthumbnailer 7zip jq poppler fd ripgrep fzf zoxide imagemagick ueberzugpp yazi"
elif command -v apt-get >/dev/null 2>&1; then
    PM="apt"
    INSTALL="sudo apt-get install -y"
    # Ubuntu usa nomes de pacotes levemente diferentes
    DEPS="ffmpegthumbnailer p7zip-full jq poppler-utils fd-find ripgrep fzf zoxide imagemagick"
else
    error "Gerenciador de pacotes não suportado. O script requer pacman ou apt."
fi

# ─── Instalação de Dependências ──────────────────────────────────────────────
info "Detectado: $PM. Instalando dependências..."
if [ "$PM" = "apt" ]; then
    sudo apt-get update -q
fi
$INSTALL $DEPS

# ─── Instalação do Yazi no Ubuntu (se necessário) ────────────────────────────
if [ "$PM" = "apt" ] && ! command -v yazi >/dev/null 2>&1; then
    info "Yazi não encontrado nos repositórios APT. Baixando binário oficial..."
    YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -L -o /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
    unzip -o /tmp/yazi.zip -d /tmp/yazi_bin
    sudo mv /tmp/yazi_bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
    sudo mv /tmp/yazi_bin/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
    rm -rf /tmp/yazi.zip /tmp/yazi_bin
    success "Yazi ${YAZI_VERSION} instalado em /usr/local/bin"
fi

# ─── GDB Dashboard ──────────────────────────────────────────────────────────
info "Configurando GDB Dashboard..."
if [ -f "$HOME/.gdbinit" ]; then
    # Evita backup recursivo se já existir um backup recente
    if ! [ -L "$HOME/.gdbinit" ]; then
        mv "$HOME/.gdbinit" "$HOME/.gdbinit.bak.$(date +%s)"
        warn "Backup do .gdbinit antigo criado."
    fi
fi
curl -sL https://git.io/.gdbinit -o "$HOME/.gdbinit"
success "GDB Dashboard instalado em ~/.gdbinit"

# ─── Integração ZSH (Aliases e Wrapper) ─────────────────────────────────────
ALIASES_FILE="$HOME/.aliases"
touch "$ALIASES_FILE"

# Limpa entradas antigas para evitar duplicidade ao rodar o script várias vezes
sed -i '/# Yazi Elite Wrapper/,/}/d' "$ALIASES_FILE"
sed -i '/alias gdbe=/d' "$ALIASES_FILE"

info "Configurando integração no $ALIASES_FILE..."
cat >> "$ALIASES_FILE" << 'EOF'

# Yazi Elite Wrapper: Muda o diretório do shell ao sair (atalho 'y')
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Atalho para o GDB Dashboard (focado no executável main)
alias gdbe='gdb -q -ex "dashboard" ./main'
EOF
success "Zsh integrado."

# ─── Integração Tmux ────────────────────────────────────────────────────────
info "Adicionando atalhos ao Tmux..."
TMUX_CONF="$HOME/.tmux.conf"
if [ -f "$TMUX_CONF" ]; then
    if ! grep -q "bind e" "$TMUX_CONF"; then
        echo -e "\n# Abrir Yazi em nova janela\nbind e new-window -c \"#{pane_current_path}\" -n \"explorer\" \"yazi\"" >> "$TMUX_CONF"
        tmux source-file "$TMUX_CONF" 2>/dev/null || true
        success "Atalho 'Ctrl+a + e' adicionado ao Tmux."
    else
        success "Atalho Tmux já configurado."
    fi
fi

# ─── Validação Final ────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════"
echo " TESTE DE INTEGRIDADE"
echo "════════════════════════════════════════════════════════════"
command -v yazi >/dev/null && echo -e "${GREEN}[OK]${RESET} Yazi instalado" || echo -e "${RED}[FALHA]${RESET} Yazi"
command -v gdb >/dev/null && echo -e "${GREEN}[OK]${RESET} GDB instalado" || echo -e "${RED}[FALHA]${RESET} GDB"
[ -f "$HOME/.gdbinit" ] && echo -e "${GREEN}[OK]${RESET} Dashboard configurado" || echo -e "${RED}[FALHA]${RESET} .gdbinit"
echo "════════════════════════════════════════════════════════════"
echo "Pronto! Na faculdade (Ubuntu) ou em casa (Arch), basta rodar:"
echo "y      -> Navegador de arquivos"
echo "gdbe   -> Debugger Visual"
echo "════════════════════════════════════════════════════════════"
