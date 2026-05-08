#!/usr/bin/env bash

# =============================================================================
# UNIVERSAL DOTFILES INSTALLER (ZSH + NEOVIM)
# =============================================================================

set -e

# Cores para feedback visual
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error()   { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }

echo "╔══════════════════════════════════════════════╗"
echo "║      MAKOM KODESH - UNIVERSAL INSTALLER      ║"
echo "╚══════════════════════════════════════════════╝"

# 1. Detecção de Sistema Operacional
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

# 2. Instalação de Dependências Básicas (Necessário para o Neovim funcionar bem)
info "Verificando dependências essenciais..."
if [[ "$OS" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
    # Arch/EndeavourOS
    PKGS="neovim zsh git curl nodejs npm python-pip ripgrep fd fzf lazygit xclip wl-clipboard"
    sudo pacman -Sy --needed --noconfirm $PKGS
elif [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    # Ubuntu/Debian
    sudo apt-get update -q
    sudo apt-get install -y git curl nodejs npm python3-pip ripgrep fzf xclip wl-clipboard
    # Neovim via AppImage para garantir versão > 0.9
    if ! command -v nvim &> /dev/null; then
        info "Instalando Neovim via AppImage..."
        curl -Lo /tmp/nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
        chmod +x /tmp/nvim.appimage
        sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
    fi
fi

# 3. Configuração do ZSH
info "Configurando ZSH..."
if [[ -f ~/.zshrc ]]; then
    mv ~/.zshrc ~/.zshrc.bak.$(date +%s)
    success "Backup do .zshrc criado"
fi
cp ./zshrc ~/.zshrc
success "Novo .zshrc instalado"

# Plugins ZSH (Instalação local para não precisar de sudo no futuro)
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "$ZSH_CUSTOM_DIR"
if [ ! -d "$ZSH_CUSTOM_DIR/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting"
fi

# 4. Configuração do Neovim (O Cérebro)
info "Configurando Neovim..."
NVIM_DIR="$HOME/.config/nvim"
if [[ -d "$NVIM_DIR" ]]; then
    mv "$NVIM_DIR" "$NVIM_DIR.bak.$(date +%s)"
    success "Backup da config antiga do Neovim criado"
fi
mkdir -p "$NVIM_DIR"
cp -r ./nvim/* "$NVIM_DIR/"
success "Configuração instalada em $NVIM_DIR"

# 5. Finalização
echo -e "\n${GREEN}🎉 AMBIENTE INSTALADO COM SUCESSO!${NC}"
echo "-------------------------------------------------------"
echo "• Para o ZSH: Digite 'zsh' para entrar no novo shell"
echo "• Para o Neovim: Digite 'nvim' e aguarde a instalação automática"
echo "-------------------------------------------------------"
