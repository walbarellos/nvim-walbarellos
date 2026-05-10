#!/usr/bin/env bash

# =============================================================================
# TMUX SMART SETUP
# =============================================================================
# Instala a bancada tmux do repo na maquina atual e recarrega a sessao aberta.

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
TMUX_SRC="$SCRIPT_DIR/tmux/tmux.conf"
TMUX_DEST="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"
CATPPUCCIN_DIR="$HOME/.tmux/plugins/catppuccin/tmux"
WHICH_KEY_DIR="$HOME/.tmux/plugins/tmux-which-key"

backup_path() {
    local path="$1"
    if [[ -e "$path" || -L "$path" ]]; then
        local backup="${path}.bak.$(date +%s)"
        mv "$path" "$backup"
        success "Backup criado: $backup"
    fi
}

install_packages_if_possible() {
    if ! command -v sudo >/dev/null 2>&1 && [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
        warn "Sem sudo. Vou configurar arquivos, mas talvez faltem pacotes."
        return
    fi

    local sudo_cmd=""
    if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
        sudo_cmd="sudo"
    fi

    if command -v pacman >/dev/null 2>&1; then
        info "Detectei Arch/pacman. Instalando dependencias do tmux..."
        # shellcheck disable=SC2086
        $sudo_cmd pacman -S --needed --noconfirm \
            tmux git fzf bat xclip wl-clipboard acpi sysstat lm_sensors \
            python python-yaml
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        info "Detectei Ubuntu/Debian/apt. Instalando dependencias do tmux..."
        # shellcheck disable=SC2086
        $sudo_cmd apt-get update -q
        # shellcheck disable=SC2086
        $sudo_cmd apt-get install -y \
            tmux git fzf bat xclip wl-clipboard acpi sysstat lm-sensors \
            python3 python3-yaml
        return
    fi

    warn "Gerenciador nao reconhecido. Instale manualmente: tmux git fzf bat xclip/wl-clipboard acpi sysstat lm_sensors python3 python3-yaml."
}

ensure_local_bin_path() {
    mkdir -p "$HOME/.local/bin"

    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [[ -f "$rc" ]] && ! grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$rc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
            success "PATH de ~/.local/bin adicionado em $rc"
        fi
    done

    export PATH="$HOME/.local/bin:$PATH"
}

configure_bat_compat() {
    ensure_local_bin_path

    if command -v bat >/dev/null 2>&1; then
        success "bat encontrado: $(command -v bat)"
        return
    fi

    if command -v batcat >/dev/null 2>&1; then
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        success "Compatibilidade criada: ~/.local/bin/bat -> $(command -v batcat)"
        return
    fi

    warn "bat/batcat nao encontrado. O sessionx ainda pode abrir, mas o preview pode ficar pior."
}

install_tmux_conf() {
    [[ -f "$TMUX_SRC" ]] || error "Config fonte nao encontrada: $TMUX_SRC"

    if [[ -f "$TMUX_DEST" ]] && cmp -s "$TMUX_SRC" "$TMUX_DEST"; then
        success "~/.tmux.conf ja esta atualizado."
        return
    fi

    backup_path "$TMUX_DEST"
    cp "$TMUX_SRC" "$TMUX_DEST"
    success "Config instalada em $TMUX_DEST"
}

clone_or_keep() {
    local repo="$1"
    local dest="$2"
    shift 2

    if [[ -d "$dest" ]]; then
        success "Ja existe: $dest"
        return
    fi

    if ! command -v git >/dev/null 2>&1; then
        warn "git nao encontrado. Nao consegui clonar $repo."
        return
    fi

    mkdir -p "$(dirname "$dest")"
    info "Clonando $repo em $dest..."
    if git clone "$@" "$repo" "$dest"; then
        success "Clonado: $dest"
    else
        warn "Falhou ao clonar $repo. Voce pode repetir depois."
    fi
}

install_tmux_plugins_base() {
    clone_or_keep "https://github.com/tmux-plugins/tpm" "$TPM_DIR" --depth=1
    clone_or_keep "https://github.com/catppuccin/tmux.git" "$CATPPUCCIN_DIR" --depth=1 -b v2.3.0
    clone_or_keep "https://github.com/alexwforsythe/tmux-which-key.git" "$WHICH_KEY_DIR" --depth=1
}

configure_tmux_which_key() {
    local example="$WHICH_KEY_DIR/config.example.yaml"
    local config="$WHICH_KEY_DIR/config.yaml"
    local build_py="$WHICH_KEY_DIR/plugin/build.py"

    if [[ ! -f "$example" ]]; then
        warn "tmux-which-key ainda nao tem config.example.yaml. Rode Ctrl+a depois I e depois bash tmux-setup.sh."
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
        success "tmux-which-key ficou prefix-only: Ctrl+a depois Space."
    else
        success "tmux-which-key ja esta prefix-only."
    fi
}

reload_tmux_if_inside() {
    if [[ -z "${TMUX:-}" ]]; then
        info "Voce nao esta dentro do tmux. A proxima sessao ja vai carregar ~/.tmux.conf."
        return
    fi

    info "Detectei uma sessao tmux aberta. Recarregando config agora..."
    tmux source-file "$TMUX_DEST"

    local prefix
    prefix="$(tmux show -gqv prefix 2>/dev/null || true)"
    success "tmux recarregado. Prefixo atual: ${prefix:-desconhecido}"
}

main() {
    install_packages_if_possible
    configure_bat_compat
    install_tmux_conf
    install_tmux_plugins_base
    configure_tmux_which_key
    reload_tmux_if_inside

    echo ""
    success "Bancada tmux pronta."
    echo "Use: tmux new -s c"
    echo "Dentro do tmux, instale/atualize plugins com: Ctrl+a depois I"
    echo "Menu visual: Ctrl+a depois Space"
}

main "$@"
