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
            neovim zsh tmux git curl nodejs npm python-pip python-virtualenv \
            ripgrep fd fzf bat lazygit xclip wl-clipboard base-devel unzip \
            gcc clang gdb cmake valgrind acpi sysstat lm_sensors \
            python python-yaml fontconfig ttf-jetbrains-mono-nerd
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        run_pkg apt-get update -q
        run_pkg apt-get install -y \
            zsh tmux git curl nodejs npm python3-pip python3-venv \
            ripgrep fd-find fzf xclip wl-clipboard build-essential unzip \
            gcc clang gdb cmake valgrind acpi sysstat lm-sensors \
            python3 python3-yaml fontconfig fonts-firacode

        install_optional_apt_package neovim
        install_optional_apt_package lazygit
        install_optional_apt_package bat

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
            neovim zsh tmux git curl nodejs npm python3-pip \
            ripgrep fd-find fzf bat lazygit xclip wl-clipboard \
            gcc gcc-c++ clang gdb cmake valgrind make unzip fontconfig \
            jetbrains-mono-fonts-all
        return
    fi

    if command -v zypper >/dev/null 2>&1; then
        run_pkg zypper --non-interactive install \
            neovim zsh tmux git curl nodejs npm python3-pip \
            ripgrep fd fzf bat xclip wl-clipboard \
            gcc gcc-c++ clang gdb cmake valgrind make unzip fontconfig \
            jetbrains-mono-fonts
        if zypper search -x lazygit >/dev/null 2>&1; then
            run_pkg zypper --non-interactive install lazygit
        else
            warn "Pacote opcional 'lazygit' não encontrado nos repositórios Zypper habilitados."
        fi
        return
    fi

    if command -v apk >/dev/null 2>&1; then
        run_pkg apk add --no-cache \
            neovim zsh tmux git curl nodejs npm py3-pip \
            ripgrep fd fzf bat lazygit xclip wl-clipboard build-base unzip \
            gcc clang gdb cmake valgrind fontconfig
        return
    fi

    if command -v xbps-install >/dev/null 2>&1; then
        run_pkg xbps-install -Sy \
            neovim zsh tmux git curl nodejs npm python3-pip \
            ripgrep fd fzf bat lazygit xclip wl-clipboard base-devel unzip \
            gcc clang gdb cmake valgrind fontconfig
        return
    fi

    warn "Gerenciador de pacotes não suportado automaticamente para ID='$ID' ID_LIKE='${ID_LIKE:-}'."
    warn "Instale manualmente: neovim zsh tmux git curl nodejs npm python3 python3-yaml pip ripgrep fd fzf bat lazygit xclip wl-clipboard gcc clang gdb cmake valgrind acpi sysstat lm_sensors make unzip fontconfig e uma Nerd Font."
}

configure_bat_compat() {
    if command -v bat >/dev/null 2>&1 || ! command -v batcat >/dev/null 2>&1; then
        return
    fi

    info "Criando compatibilidade bat -> batcat em ~/.local/bin..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"

    if [[ -f "$HOME/.zshrc" ]] && ! grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi

    success "Compatibilidade bat criada em $HOME/.local/bin/bat"
}

reload_tmux_if_inside() {
    local tmux_conf="$1"

    if [[ -z "${TMUX:-}" ]]; then
        return
    fi

    info "Sessão tmux detectada. Recarregando $tmux_conf..."
    if tmux source-file "$tmux_conf"; then
        success "tmux recarregado. Prefixo atual: $(tmux show -gqv prefix 2>/dev/null || echo desconhecido)"
    else
        warn "Não foi possível recarregar o tmux automaticamente. Rode: tmux source-file $tmux_conf"
    fi
}

install_user_nerd_font() {
    if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi "Nerd Font"; then
        success "Nerd Font já encontrada no sistema."
        return
    fi

    info "Instalando JetBrainsMono Nerd Font para o usuário atual..."

    local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
    local zip_path="/tmp/JetBrainsMonoNerdFont.zip"

    mkdir -p "$font_dir"
    curl -L -o "$zip_path" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o "$zip_path" -d "$font_dir" >/dev/null
    rm -f "$zip_path"

    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$HOME/.local/share/fonts"
    fi

    success "JetBrainsMono Nerd Font instalada em $font_dir"
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

configure_tmux_which_key() {
    local which_key_dir="$HOME/.tmux/plugins/tmux-which-key"
    local example="$which_key_dir/config.example.yaml"
    local config="$which_key_dir/config.yaml"
    local build_py="$which_key_dir/plugin/build.py"

    if [[ ! -f "$example" ]]; then
        warn "tmux-which-key ainda não está instalado. Depois de Ctrl+a I, rode: bash tmux-setup.sh"
        return
    fi

    if [[ -f "$build_py" ]] && grep -q 'from pyyaml.lib import yaml' "$build_py"; then
        sed -i 's/from pyyaml\.lib import yaml/try:\n    from pyyaml.lib import yaml\nexcept ModuleNotFoundError:\n    import yaml/' "$build_py"
        success "Patch de compatibilidade PyYAML aplicado ao tmux-which-key."
    fi

    if [[ ! -f "$config" ]]; then
        cp "$example" "$config"
        success "Criado config.yaml do tmux-which-key."
    fi

    if grep -q '^[[:space:]]*root_table:' "$config"; then
        sed -i '/^[[:space:]]*root_table:/d' "$config"
        success "tmux-which-key configurado como prefix-only: Ctrl+a depois Espaço."
    else
        success "tmux-which-key já está prefix-only."
    fi
}

install_tmux_config() {
    info "Configurando tmux..."

    local tmux_conf="$HOME/.tmux.conf"
    local catppuccin_dir="$HOME/.tmux/plugins/catppuccin/tmux"
    local which_key_dir="$HOME/.tmux/plugins/tmux-which-key"

    backup_path "$tmux_conf"
    cp "$SCRIPT_DIR/tmux/tmux.conf" "$tmux_conf"
    success "Configuração instalada em $tmux_conf"

    if [[ -d "$catppuccin_dir" ]]; then
        success "Catppuccin tmux já está instalado em $catppuccin_dir"
    else
        info "Instalando Catppuccin tmux em $catppuccin_dir..."
        mkdir -p "$(dirname "$catppuccin_dir")"
        if git clone --depth=1 -b v2.3.0 https://github.com/catppuccin/tmux.git "$catppuccin_dir"; then
            success "Catppuccin tmux instalado."
        else
            warn "Não foi possível clonar o Catppuccin agora. Rode depois: git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.tmux/plugins/catppuccin/tmux"
        fi
    fi

    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        success "TPM já está instalado em $tpm_dir"
    else
        info "Instalando TPM em $tpm_dir..."
        if git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"; then
            success "TPM instalado. Dentro do tmux, use Ctrl+a depois I para instalar os plugins."
        else
            warn "Não foi possível clonar o TPM agora. Rode depois: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
        fi
    fi

    if [[ -d "$which_key_dir" ]]; then
        success "tmux-which-key já está instalado em $which_key_dir"
    else
        info "Instalando tmux-which-key em $which_key_dir..."
        if git clone --depth=1 https://github.com/alexwforsythe/tmux-which-key.git "$which_key_dir"; then
            success "tmux-which-key instalado."
        else
            warn "Não foi possível clonar o tmux-which-key agora. Rode depois: git clone https://github.com/alexwforsythe/tmux-which-key.git ~/.tmux/plugins/tmux-which-key"
        fi
    fi

    configure_tmux_which_key

    reload_tmux_if_inside "$tmux_conf"
}

if [[ "${1:-}" == "--fonts-only" ]]; then
    install_user_nerd_font
    echo "-------------------------------------------------------"
    echo "• Fonte instalada/validada."
    echo "• Selecione 'JetBrainsMono Nerd Font Mono' no terminal."
    echo "• Feche e abra o terminal depois da troca."
    echo "-------------------------------------------------------"
    exit 0
fi

install_packages
install_user_nerd_font
install_zsh_config
configure_bat_compat
install_neovim_config
install_tmux_config

echo -e "\n${GREEN}🎉 AMBIENTE INSTALADO COM SUCESSO!${NC}"
echo "-------------------------------------------------------"
echo "• Para testar o ZSH agora: zsh"
echo "• Para tornar o ZSH padrão: CHANGE_SHELL=1 bash install.sh"
echo "• Para o Neovim: nvim"
echo "• Para o tmux: tmux new -s c"
echo "-------------------------------------------------------"
