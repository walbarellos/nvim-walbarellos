# Nabur's Neovim Config

Config completa pra programar C, C++, Python, Lua, JS/TS, Bash, Portugol.
Funciona em Arch, Ubuntu, Fedora.

## Instalação rápida

```bash
bash install.sh
```

## Estrutura

```
├── init.lua                  # Ponto de entrada
├── lua/
│   ├── core/
│   │   ├── options.lua       # Configurações do editor
│   │   ├── keymaps.lua       # Atalhos base
│   │   └── autocmds.lua      # Automações
│   └── plugins/
│       ├── ui.lua            # Tema, statusline, explorador, dashboard
│       ├── telescope.lua     # Busca de arquivos e texto
│       ├── treesitter.lua    # Sintaxe e text objects
│       ├── lsp.lua           # Language servers (erros, autocomplete)
│       ├── completion.lua    # Menu de autocomplete
│       ├── editor.lua        # autopairs, surround, comment, flash
│       ├── formatting.lua    # Formatação e linting
│       ├── git.lua           # gitsigns, lazygit, diffview
│       ├── terminal.lua      # Terminal flutuante
│       └── debug.lua         # Debugger (DAP)
└── after/syntax/
    └── portugol.vim          # Highlight pra Portugol
```

## Atalhos principais

| Tecla         | Ação                        |
|---------------|-----------------------------|
| `<Space>?`    | Ver todos os atalhos        |
| `<Space>ff`   | Buscar arquivo              |
| `<Space>fg`   | Buscar texto no projeto     |
| `<Space>e`    | Explorador de arquivos      |
| `<C-\>`       | Terminal flutuante          |
| `<Space>lg`   | LazyGit                     |
| `<Space>L`    | Lazy (gerenciador plugins)  |
| `<Space>M`    | Mason (gerenciador LSPs)    |
| `gd`          | Ir pra definição            |
| `K`           | Documentação hover          |
| `<Space>ca`   | Code action                 |
| `<Space>rn`   | Renomeia símbolo            |
| `<Space>cf`   | Formata arquivo             |
| `<Space>xx`   | Lista de erros              |
| `gcc`         | Comenta linha               |
| `s`           | Flash: pula pra qualquer lugar |
| `]h` / `[h`   | Navega entre hunks git      |

## Requisitos

- Neovim ≥ 0.9
- Nerd Font no terminal ([nerdfonts.com](https://www.nerdfonts.com/))
- git, curl, node, python3, gcc, ripgrep
