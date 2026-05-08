#!/usr/bin/env bash

# =============================================================================
# UNIVERSAL DOTFILES INSTALLER (ZSH + NEOVIM)
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔══════════════════════════════════════════════╗"
echo "║      MAKOM KODESH - UNIVERSAL INSTALLER      ║"
echo "╚══════════════════════════════════════════════╝"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
else
    ID="unknown"
    ID_LIKE=""
fi

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    error "Este instalador precisa de sudo ou precisa ser executado como root para instalar pacotes."
fi

run_pkg() {
    info "Executando: $*"
    # shellcheck disable=SC2086
    $SUDO "$@"
}

install_optional_apt_package() {
    local pkg="$1"
    if apt-cache show "$pkg" >/dev/null 2>&1; then
        run_pkg apt-get install -y "$pkg"
    else
        warn "Pacote opcional '$pkg' não encontrado nos repositórios APT habilitados."
    fi
}

install_packages() {
    info "Detectando gerenciador de pacotes e instalando dependências essenciais..."

    if command -v pacman >/dev/null 2>&1; then
        run_pkg pacman -Sy --needed --noconfirm \
            neovim zsh git curl nodejs npm python-pip python-virtualenv \
            ripgrep fd fzf lazygit xclip wl-clipboard base-devel unzip \
            gcc clang gdb cmake valgrind
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        run_pkg apt-get update -q
        run_pkg apt-get install -y \
            zsh git curl nodejs npm python3-pip python3-venv \
            ripgrep fd-find fzf xclip wl-clipboard build-essential unzip \
            gcc clang gdb cmake valgrind

        install_optional_apt_package neovim
        install_optional_apt_package lazygit

        if ! command -v nvim >/dev/null 2>&1; then
            info "Instalando Neovim via AppImage porque 'nvim' não foi encontrado."
            curl -L -o /tmp/nvim.appimage \
                https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
            chmod +x /tmp/nvim.appimage
            run_pkg mv /tmp/nvim.appimage /usr/local/bin/nvim
        fi
        return
    fi

    if command -v dnf >/dev/null 2>&1; then
        run_pkg dnf install -y \
            neovim zsh git curl nodejs npm python3-pip \
            ripgrep fd-find fzf lazygit xclip wl-clipboard \
            gcc gcc-c++ clang gdb cmake valgrind make unzip
        return
    fi

    if command -v zypper >/dev/null 2>&1; then
        run_pkg zypper --non-interactive install \
            neovim zsh git curl nodejs npm python3-pip \
            ripgrep fd fzf xclip wl-clipboard \
            gcc gcc-c++ clang gdb cmake valgrind make unzip
        if zypper search -x lazygit >/dev/null 2>&1; then
            run_pkg zypper --non-interactive install lazygit
        else
            warn "Pacote opcional 'lazygit' não encontrado nos repositórios Zypper habilitados."
        fi
        return
    fi

    if command -v apk >/dev/null 2>&1; then
        run_pkg apk add --no-cache \
            neovim zsh git curl nodejs npm py3-pip \
            ripgrep fd fzf lazygit xclip wl-clipboard build-base unzip \
            gcc clang gdb cmake valgrind
        return
    fi

    if command -v xbps-install >/dev/null 2>&1; then
        run_pkg xbps-install -Sy \
            neovim zsh git curl nodejs npm python3-pip \
            ripgrep fd fzf lazygit xclip wl-clipboard base-devel unzip \
            gcc clang gdb cmake valgrind
        return
    fi

    warn "Gerenciador de pacotes não suportado automaticamente para ID='$ID' ID_LIKE='${ID_LIKE:-}'."
    warn "Instale manualmente: neovim zsh git curl nodejs npm python3 pip ripgrep fd fzf lazygit xclip wl-clipboard gcc clang gdb cmake valgrind make unzip."
}

backup_path() {
    local path="$1"
    if [[ -e "$path" || -L "$path" ]]; then
        local backup="${path}.bak.$(date +%s)"
        mv "$path" "$backup"
        success "Backup criado: $backup"
    fi
}

install_zsh_config() {
    info "Configurando ZSH..."

    if ! command -v zsh >/dev/null 2>&1; then
        error "zsh não foi encontrado após a instalação de pacotes."
    fi

    backup_path "$HOME/.zshrc"
    cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    success "Novo .zshrc instalado em $HOME/.zshrc"

    local zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$zsh_custom_dir"

    if [[ ! -d "$zsh_custom_dir/zsh-autosuggestions" ]]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
            "$zsh_custom_dir/zsh-autosuggestions"
    fi

    if [[ ! -d "$zsh_custom_dir/zsh-syntax-highlighting" ]]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
            "$zsh_custom_dir/zsh-syntax-highlighting"
    fi

    success "Plugins do ZSH instalados em $zsh_custom_dir"

    if [[ "${CHANGE_SHELL:-0}" == "1" ]]; then
        local zsh_path
        zsh_path="$(command -v zsh)"

        if ! grep -qxF "$zsh_path" /etc/shells; then
            echo "$zsh_path" | $SUDO tee -a /etc/shells >/dev/null
        fi

        chsh -s "$zsh_path" "$USER"
        success "Shell padrão alterado para $zsh_path. Faça logout/login para aplicar."
    else
        warn "Shell padrão não foi alterado. Para trocar automaticamente, rode: CHANGE_SHELL=1 bash install.sh"
    fi
}

install_neovim_config() {
    info "Configurando Neovim..."

    local nvim_dir="$HOME/.config/nvim"
    backup_path "$nvim_dir"
    mkdir -p "$nvim_dir"
    cp -r "$SCRIPT_DIR/nvim/." "$nvim_dir/"
    success "Configuração instalada em $nvim_dir"
}

install_packages
install_zsh_config
install_neovim_config

echo -e "\n${GREEN}🎉 AMBIENTE INSTALADO COM SUCESSO!${NC}"
echo "-------------------------------------------------------"
echo "• Para testar o ZSH agora: zsh"
echo "• Para tornar o ZSH padrão: CHANGE_SHELL=1 bash install.sh"
echo "• Para o Neovim: nvim"
echo "-------------------------------------------------------"
