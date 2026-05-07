# 🌌 Makom Kodesh - Dotfiles Unificados

Bem-vindo ao seu **Cérebro Digital**. Este repositório contém a configuração definitiva para o seu ambiente de desenvolvimento, unificando o poder do **ZSH** com a velocidade "God Mode" do **Neovim**.

Desenvolvido com foco em **soberania cognitiva**, **estética de elite** e **portabilidade total** para que você possa levar seu ambiente da sua máquina pessoal direto para a faculdade ou qualquer servidor remoto.

---

## 🚀 Instalação Relâmpago

Para recriar este ambiente em qualquer máquina (Linux/Arch recomendado):

```bash
git clone git@github.com:walbarellos/mypersonal-zsh-config.git
cd mypersonal-zsh-config
bash install.sh
```

**O que o instalador faz por você:**
1.  **Backup**: Protege suas configurações antigas criando arquivos `.bak`.
2.  **ZSH**: Instala o `.zshrc` e plugins de produtividade (autosuggestions, syntax highlighting).
3.  **Neovim**: Instala a configuração modular completa em `~/.config/nvim`.
4.  **Auto-Bootstrap**: Na primeira vez que você abrir o `nvim`, ele baixará todos os plugins sozinho.

---

## 🛠️ Neovim: Guia de Sobrevivência (God Mode)

Seu Neovim não é apenas um editor, é um **IDE de Próxima Geração**.

### 🎹 Teclas Fundamentais (O Fluxo)
*   **A Tecla Mestra**: Tudo começa com o **`<Espaço>`** (Leader Key).
*   **Sem Pressa**: Não segure as teclas. Pressione o Espaço, solte, e depois a próxima tecla.
*   **Dica de Ouro**: Se você apertar o **Espaço** e esperar meio segundo, uma janela (Which-Key) abrirá mostrando todos os atalhos possíveis!

### 🔍 Navegação e Busca (Telescope)
| Atalho | Ação |
| :--- | :--- |
| `<Espaço> f f` | **F**ind **F**iles: Busca arquivos pelo nome. |
| `<Espaço> f g` | **F**ind **G**rep: Busca palavras dentro de todos os arquivos. |
| `<Espaço> f r` | **R**ecent: Abre arquivos editados recentemente. |
| `<Espaço> e`   | **E**xplorer: Abre/fecha a barra lateral de pastas. |

### ⚡ Teletransporte e Edição (Plugins de Elite)
*   **Flash (`s`)**: O atalho mais poderoso. Aperte `s` e digite as duas primeiras letras de qualquer palavra que você está vendo na tela. O Neovim mostrará uma letra em cima do alvo; aperte essa letra e seu cursor "teletransportará" para lá.
*   **Autopairs**: Parênteses `()`, chaves `{}` e aspas `""` fecham automaticamente.
*   **GitSigns**: Veja barras coloridas no canto esquerdo indicando linhas novas (`+`), modificadas (`|`) ou deletadas (`-`). Use `]h` para pular para a próxima mudança.

---

## 🎨 Personalização e Estética

### 🍦 O Tema: Catppuccin (Mocha)
Seu tema atual é o **Catppuccin Mocha**, famoso pela suavidade e conforto visual em sessões longas de codificação.

**Como trocar de sabor (Mocha, Macchiato, Frappe, Latte):**
1.  Abra o arquivo de UI: `nvim ~/.config/nvim/lua/plugins/ui.lua`
2.  Procure pela linha `flavour = "mocha"`.
3.  Mude para `"macchiato"` ou `"latte"` e salve com `:w`.

---

## 📦 Lista de Plugins (Must Have)

*   **Fundação**: `lazy.nvim` (gerenciador), `mason.nvim` (instalador de LSPs).
*   **Inteligência**: `nvim-lspconfig` (IDE features), `nvim-treesitter` (syntax de elite).
*   **Visual**: `lualine` (barra inferior), `bufferline` (abas no topo), `noice.nvim` (notificações lindas).
*   **Utilidades**: `telescope` (busca), `trouble.nvim` (lista de erros), `which-key` (dicionário de atalhos).

---

## 🖋️ Créditos e Filosofia

Este ambiente foi construído seguindo os princípios do **Clear-Team**:
*   **Substrate (Serra)**: Base sólida e modular em Lua.
*   **Phenotype (Aris)**: Estética impecável com ícones e transparências.
*   **Vision (Julian)**: Ferramentas que protegem sua atenção.

Feito com ❤️ para o **Walbarellos**. Que este código te acompanhe em todas as suas conquistas acadêmicas e profissionais! 🥒
