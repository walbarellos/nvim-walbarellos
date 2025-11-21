alias projetos="cd /mnt/backup/AI-Project/Projetos/"



# ===== Base =====
export EDITOR=vim
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups share_history

# Se não for Zsh, sai (protege caso rodem 'source ~/.zshrc' no bash)
[ -n "$ZSH_VERSION" ] || return

# ===== Completion =====
autoload -Uz compinit && compinit

# ===== Prompt =====
autoload -Uz promptinit && promptinit
prompt walters    # pode trocar pra 'adam2', 'fade', etc.

# ===== Keybindings =====
bindkey -e        # estilo Emacs; use 'bindkey -v' pra estilo Vim

# ===== Plugins =====
# Autosuggestions
if [ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting (SEMPRE por último)
if [ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Carregar aliases
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# ~/.aliases
encontre() {
    if [ -z "$1" ]; then
        echo "Uso: encontre \"texto a procurar\""
        return 1
    fi

    local resultados
    resultados=$(grep -RIn \
        --color=never \
        --exclude-dir='.git' \
        --exclude-dir='build' \
        --exclude-dir='dist' \
        --exclude-dir='.cache' \
        --exclude-dir='node_modules' \
        --exclude-dir='.venv' \
        --exclude-dir='.wine' \
        --exclude-dir='SteamLibrary' \
        --exclude='*.log' \
        --exclude='*.mp4' \
        --exclude='*.png' \
        --exclude='*.jpg' \
        --exclude='*.jpeg' \
        "$1" . 2>/dev/null | grep -v '\.wine' | uniq)

    if [ -z "$resultados" ]; then
        echo "Nenhum resultado."
        return 0
    fi

    echo "$resultados" | while IFS=: read -r file line content; do
        printf "\033[1;36m→ %s\033[0m \033[1;33m(linha %s)\033[0m\n" "$file" "$line"
        printf "     %s\n\n" "$content"
    done
}

# Atualizar sistema
alias upd="sudo pacman -Syu"

# Criar e ativar venv Python
alias mkvenv="python -m venv .venv && source .venv/bin/activate"

# Git helpers
alias gcm="git commit -m"
alias gca="git add . && git commit -m"
alias gps="git push"

# Zipar diretório atual
alias zipar='zip -r "$(basename $(pwd)).zip" .'

# Descompactar rápido
alias unzipar='unzip'

# Ir para HD de 1TB
alias hdd="cd /mnt/data"

# Projetos
alias proj="cd /mnt/data/Projetos"
alias steamd="cd /mnt/data/SteamLibrary"

# Limpeza pacman
alias clean="sudo pacman -Rns \$(pacman -Qdtq)"


# alias para zipar: zipar NomeDaPasta
alias zipar='f() { zip -r "${1%/}.zip" "$1" \
  -x "*.git*" \
  -x "*/android/*" \
  -x "*node_modules*" \
  -x "*.env" \
  -x "*__pycache__*" \
  -x "*.pyc" \
  -x "*.log" \
  -x "*.DS_Store" \
  -x "*.sqlite3" \
  -x "*/dist/*" \
  -x "*/build/*" \
  -x "*.cache/*" \
  && echo "✅ Zip criado: ${1%/}.zip"; }; f'

# ═════════════════════🧪 VENV INTELIGENTE (criarvenv) ═════════════════════

unalias criarvenv 2>/dev/null

criarvenv() {
  echo "🐍 Criando ambiente virtual Python..."
  python -m venv .venv || { echo "❌ Erro ao criar venv"; return 1; }

  echo "✅ Ambiente .venv criado. Ativando..."
  source .venv/bin/activate || { echo "❌ Falha ao ativar .venv"; return 1; }

  echo "🧠 Ambiente virtual ativado."

  if [[ -f requirements.txt ]]; then
    echo "📦 Instalando dependências do requirements.txt..."
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    echo "✅ Pacotes instalados com sucesso."
  else
    echo "⚠️ Nenhum requirements.txt encontrado na pasta atual."
  fi
}

# ═════════════════════🌀 Removedor de pastas e arquivos INTELIGENTE (rm rf) ═════════════════════

remover() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Você precisa passar o nome da pasta para remover."
    echo "📦 Exemplo: remover nome-da-pasta"
    return 1
  fi

  if [[ -d "$1" ]]; then
    echo "❗ Tem certeza que deseja remover a pasta '$1'? (s/n)"
    read -r resposta
    if [[ "$resposta" == [sS] ]]; then
      rm -rf -- "$1"
      echo "🗑️  Pasta '$1' removida com sucesso."
    else
      echo "❌ Remoção cancelada."
    fi
  else
    echo "🚫 Pasta '$1' não encontrada."
    return 1
  fi
}

manda() {
  # 1) Valida repositório
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf "\033[1;31m[ERRO]\033[0m Não parece ser um repositório Git válido.\n"
    return 1
  fi

  # 2) Mensagem de commit (inteligente)
  local msg

  if [[ -n "$*" ]]; then
    msg="$*"
  else
    # Gera mensagem automática com base nos arquivos alterados
    local changes
    changes=$(git diff --cached --name-only)
    [[ -z "$changes" ]] && changes=$(git diff --name-only)

    if [[ -n "$changes" ]]; then
      msg="update: $(echo "$changes" | tr '\n' ' ')"
    else
      msg="update"
    fi
  fi

  printf "\033[1;34m[🧠]\033[0m Adicionando tudo (git add -A)...\n"
  git add -A

  printf "\033[1;36m[✍️]\033[0m Commitando: %s\n" "$msg"
  if ! git commit -m "$msg"; then
    printf "\033[1;33m[ℹ]\033[0m Nada para commitar (working tree limpo).\n"
  fi

  # 3) Determina branch atual
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD)"

  # 4) Verifica remoto origin
  if ! git remote get-url origin >/dev/null 2>&1; then
    printf "\033[1;31m[ERRO]\033[0m Não há remoto 'origin' configurado.\n"
    printf "      Ex.: git remote add origin git@github.com:SEU-USUARIO/SEU-REPO.git\n"
    return 1
  fi

  # 5) Push com upstream se ainda não existir
  printf "\033[1;32m[🚀]\033[0m Enviando push...\n"
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    git push || return $?
  else
    git push -u origin "$branch" || return $?
  fi

  printf "\033[1;32m[✅]\033[0m Push enviado para branch %s!\n" "$branch"
}



compilar() {
    local LOG="/mnt/backup/AI-Project/Projetos/Erros-Logs/log.txt"

    echo "🧹 Limpando build..."
    make clean > "$LOG" 2>&1

    echo "🔨 Compilando..."
    make >> "$LOG" 2>&1

    echo "📄 Log salvo em: $LOG"
    echo "--------------------------------------"
    tail -n 40 "$LOG"
}


# ═════════════════════🌐 GIT CLONE AUTOMÁTICO ═════════════════════

function clone_github_if_url() {
  if [[ $BUFFER =~ ^https://github\.com/.+\.git$ ]]; then
    zle -I
    local url="$BUFFER"
    local name="${url##*/}"
    name="${name%.git}"
    git clone "$url" "$name" && cd "$name"
    BUFFER=""
    zle reset-prompt
    return 0
  fi
  zle .accept-line
}
zle -N accept-line clone_github_if_url


# Adicione isso ao seu ~/.zshrc
source ~/.zplug/init.zsh

# Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

# Instalar caso não estejam instalados
if ! zplug check --verbose; then
    zplug install
fi

# Carregar os plugins
zplug load

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
