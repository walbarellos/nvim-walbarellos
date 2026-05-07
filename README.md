# 🌌 Makom Kodesh - Dotfiles Unificados

Ambiente de desenvolvimento unificando ZSH e Neovim. Focado em performance e portabilidade.

---

## 🚀 Instalação

```bash
git clone git@github.com:walbarellos/nvim-walbarellos.git
cd nvim-walbarellos
bash install.sh
```

**Conteúdo do instalador:**
1. **Backup**: Cria arquivos `.bak` para configurações existentes.
2. **ZSH**: Instala `.zshrc` e plugins (autosuggestions, syntax highlighting).
3. **Neovim**: Instala a configuração modular em `~/.config/nvim`.
4. **Plugins**: Gerenciados via `lazy.nvim`, instalados no primeiro boot.

---

## 🛠️ Neovim: Atalhos e Plugins

### 🎹 Comandos Base
* **Leader Key**: `<Espaço>`
* **Menu de Atalhos**: Pressione `<Espaço>` e aguarde para abrir o `which-key`.

### 🔍 Navegação (Telescope)
| Atalho | Ação |
| :--- | :--- |
| `<Espaço> ff` | Busca arquivos pelo nome. |
| `<Espaço> fg` | Busca texto (grep) em todos os arquivos. |
| `<Espaço> fr` | Abre arquivos recentes. |
| `<Espaço> e`  | Alterna o explorador de arquivos (NvimTree). |

### ⚡ Plugins de Elite
* **Flash (`s`)**: Teletransporte de cursor.
* **Autopairs**: Fechamento automático de delimitadores.
* **GitSigns**: Indicadores de alteração Git na margem da linha.

---

## 🎨 Personalização

### Tema: Catppuccin (Mocha)
Para alterar o estilo:
1. Edite `~/.config/nvim/lua/plugins/ui.lua`.
2. Altere `flavour = "mocha"` para `macchiato`, `frappe` ou `latte`.

---

## 📦 Inventário de Plugins
* **LSP**: `nvim-lspconfig`, `mason.nvim`, `lspsaga.nvim`.
* **Sintaxe**: `nvim-treesitter`.
* **Interface**: `lualine`, `bufferline`, `noice.nvim`, `nvim-tree`.
* **Busca**: `telescope.nvim`.
* **Utilidades**: `trouble.nvim`, `gitsigns.nvim`, `flash.nvim`, `autopairs`.
