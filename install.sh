#!/usr/bin/env bash

# =============================================================================
# UNIFIED DOTFILES INSTALLER (ZSH + NEOVIM)
# =============================================================================

set -e

echo "🐚 Iniciando instalação do ambiente Makom Kodesh..."

# -----------------------------------------------------------------------------
# 1. CONFIGURAÇÃO DO ZSH
# -----------------------------------------------------------------------------
echo "📦 Configurando ZSH..."

if [[ -f ~/.zshrc ]]; then
  cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
  echo "✅ Backup do .zshrc criado"
fi

cp ./zshrc ~/.zshrc
echo "✅ Novo .zshrc instalado"

# Plugins do ZSH
ZSH_PLUGINS_DIR="/usr/share/zsh/plugins"
if [[ ! -d "$ZSH_PLUGINS_DIR" ]]; then
    echo "🔧 Criando diretório de plugins (pode pedir sudo)..."
    sudo mkdir -p "$ZSH_PLUGINS_DIR"
fi

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
  echo "📥 Instalando zsh-autosuggestions..."
  sudo git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
  echo "📥 Instalando zsh-syntax-highlighting..."
  sudo git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# -----------------------------------------------------------------------------
# 2. CONFIGURAÇÃO DO NEOVIM
# -----------------------------------------------------------------------------
echo "📦 Configurando Neovim..."

NVIM_CONF_DIR="$HOME/.config/nvim"

if [[ -d "$NVIM_CONF_DIR" ]]; then
  mv "$NVIM_CONF_DIR" "$NVIM_CONF_DIR.bak.$(date +%s)"
  echo "✅ Backup da config antiga do Neovim criado"
fi

mkdir -p "$NVIM_CONF_DIR"
cp -r ./nvim/* "$NVIM_CONF_DIR/"
echo "✅ Configuração do Neovim instalada em $NVIM_CONF_DIR"

# -----------------------------------------------------------------------------
# 3. VERIFICAÇÃO DE DEPENDÊNCIAS
# -----------------------------------------------------------------------------
if ! command -v nvim &> /dev/null; then
  echo "⚠️ AVISO: Neovim não está instalado."
  echo "👉 Dica: No Arch/EndeavourOS: sudo pacman -S neovim"
else
  echo "🚀 Neovim detectado! Plugins serão instalados ao abrir pela primeira vez."
fi

echo ""
echo "🎉 AMBIENTE INSTALADO COM SUCESSO!"
echo "Aperte 'nvim' para começar."
