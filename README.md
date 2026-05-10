# Nabur's Neovim Config

Configuração pessoal de Neovim focada em programação com C, C++, Python, Lua,
JavaScript/TypeScript, Bash, Markdown, JSON/YAML e Portugol.

Ela usa `lazy.nvim` como gerenciador de plugins, `mason.nvim` para instalar
ferramentas de linguagem, LSP para inteligência de código, autocomplete,
formatação automática, integração com Git, terminal embutido, debugger e uma
bancada de estudo com `tmux`.

## O Que Esta Config Já Entrega

Para um programador, esta configuração já cobre o núcleo de uma estação moderna:

- navegação rápida por arquivos e texto com Telescope;
- LSP para definição, referências, rename, hover e diagnósticos;
- autocomplete com snippets;
- Treesitter para sintaxe e seleção estrutural;
- formatação automática e linting;
- integração com Git, hunks, blame, diffs e LazyGit;
- terminal integrado;
- debugger com DAP;
- organização modular para manutenção.

O que engenheiros fortes costumam valorizar não é uma lista infinita de plugins,
mas previsibilidade: abrir projeto, navegar rápido, entender erros, modificar
código, rodar testes, debugar, commitar e voltar ao fluxo sem fricção.

## O Que Ainda Pode Faltar

Para ficar mais completa como ambiente de programação profissional, os próximos
passos mais úteis seriam:

- integração de testes por linguagem, por exemplo `neotest`;
- melhor suporte a projetos grandes com `project.nvim` ou configuração própria
  de workspaces;
- busca estrutural/refatoração com ferramentas como `ast-grep`;
- suporte explícito a Docker, Compose, Terraform ou Kubernetes, se fizer parte
  do seu trabalho;
- keymaps para rodar build/test/lint do projeto atual;
- integração com IA local/remota, se você quiser usar assistentes dentro do
  editor;
- perfis por máquina, separando faculdade, casa e servidores;
- documentação de troubleshooting por linguagem.

Minha recomendação: primeiro estabilizar instalação, LSP, formatação, Git e
debug. Depois adicionar teste e tarefas de projeto. Isso dá mais retorno do que
encher a config de plugins visuais.

## Visão Geral

Esta configuração é modular. O arquivo `nvim/init.lua` é o ponto de entrada:

1. Carrega opções básicas do editor.
2. Carrega atalhos globais.
3. Carrega comandos automáticos.
4. Instala/carrega o `lazy.nvim`.
5. Pede para o `lazy.nvim` carregar tudo que está em `nvim/lua/plugins/`.

O fluxo principal é:

```text
nvim/init.lua
  -> lua/core/options.lua
  -> lua/core/keymaps.lua
  -> lua/core/autocmds.lua
  -> lazy.nvim
      -> lua/plugins/*.lua
```

## Instalação

```bash
git clone git@github.com:walbarellos/nvim-walbarellos.git
cd nvim-walbarellos
bash install.sh
```

Instaladores disponíveis:

| Script | Quando usar |
| --- | --- |
| `install.sh` | Instalação principal: Neovim, ZSH, C, Python, Web, fonte e config base |
| `install-extras.sh` | Opcional: Kotlin, Docker, PostgreSQL/SQL e FastAPI |
| `tmux-setup.sh` | Repara/instala só a bancada tmux na máquina atual |

Para faculdade com C/Python/HTML/CSS/JS, use só:

```bash
bash install.sh
```

Se também quiser os extras:

```bash
bash install.sh
bash install-extras.sh
```

Se estiver numa máquina da faculdade, ou se `Ctrl+a` ainda estiver indo para o
começo da linha, rode só o reparo inteligente do tmux:

```bash
bash tmux-setup.sh
```

Esse script detecta Arch/Ubuntu, instala dependências quando possível, copia
`tmux/tmux.conf` para `~/.tmux.conf`, corrige `batcat` para `bat`, instala TPM e
Catppuccin, e recarrega a sessão se você já estiver dentro do tmux.

O instalador:

- detecta a distribuição Linux;
- instala dependências básicas;
- instala `zsh` quando ele ainda não existe;
- instala `tmux` para sessões persistentes de estudo;
- faz backup do `~/.zshrc` antigo, se existir;
- instala o `.zshrc` do repositório;
- instala plugins de ZSH;
- faz backup do `~/.config/nvim` antigo, se existir;
- copia a pasta `nvim/` do repo para `~/.config/nvim`.
- copia `tmux/tmux.conf` para `~/.tmux.conf`;
- instala o TPM em `~/.tmux/plugins/tpm`, se ainda não existir.
- instala o Catppuccin tmux em `~/.tmux/plugins/catppuccin/tmux`.

Depois da instalação:

```bash
nvim
```

Na primeira abertura, o `lazy.nvim`, o `mason.nvim` e os plugins podem baixar
dependências automaticamente.

Para abrir uma bancada de C com sessão persistente:

```bash
tmux new -s c
```

Na primeira vez dentro do tmux, instale os plugins com:

```text
Ctrl+a depois I
```

Por padrão, o instalador não troca seu shell de login. Para instalar e também
tornar o ZSH o shell padrão:

```bash
CHANGE_SHELL=1 bash install.sh
```

Para instalar apenas a Nerd Font, sem mexer no ZSH nem no Neovim:

```bash
bash install.sh --fonts-only
```

## Requisitos

- Neovim 0.9 ou superior.
- Git.
- Tmux.
- Curl.
- Node.js e npm.
- Python 3 e pip.
- GCC/Make para compilar alguns plugins nativos.
- `ripgrep`, usado por buscas rápidas.
- `fd`, usado por algumas buscas/listagens.
- `fzf`, útil no terminal.
- `bat`, usado pelo seletor de sessões do tmux.
- `acpi`, `sysstat` e `lm_sensors`/`lm-sensors`, usados por módulos de status
  do tmux.
- `python-yaml` no Arch ou `python3-yaml` no Ubuntu, usado pelo menu
  customizável do `tmux-which-key`.
- `lazygit`, para a interface Git dentro do Neovim.
- Uma Nerd Font no terminal, para ícones renderizarem corretamente.

Para a stack da faculdade/casa, o instalador também tenta garantir:

| Área | Ferramentas de sistema |
| --- | --- |
| C | `gcc`, `clang`, `gdb`, `make`, `cmake`, `valgrind` |
| Python | `python3`, `pip`, `venv` |
| HTML/CSS/JS | `nodejs`, `npm`, `prettier`, `eslint_d` via Mason |
| Shell | `shellcheck`, `shfmt` via Mason |

O `install.sh` suporta automaticamente distros com:

- `pacman`, como Arch e EndeavourOS;
- `apt-get`, como Ubuntu, Debian e derivados;
- `dnf`, como Fedora;
- `zypper`, como openSUSE;
- `apk`, como Alpine;
- `xbps-install`, como Void Linux.

No Ubuntu/Debian, `lazygit` e `neovim` podem depender dos repositórios
habilitados. Se `nvim` não existir depois da instalação por APT, o script tenta
instalar o AppImage oficial mais recente do Neovim em `/usr/local/bin/nvim`.

## Stack da Faculdade

Esta configuração está preparada para o conjunto comum de disciplinas iniciais:

- C para algoritmos, estruturas de dados e programação de baixo nível;
- Python para scripts, automação, dados e exercícios rápidos;
- HTML/CSS/JavaScript para web;
- Bash para terminal e automação simples.

### C

No Neovim:

- `clangd` fornece autocomplete, erros, definição e referências;
- `clang-format` formata C/C++;
- `codelldb` dá suporte a debug via DAP;
- `gdb` fica disponível no sistema para uso direto no terminal;
- `valgrind` ajuda a achar vazamentos de memória.
- LuaSnip fornece snippets prontos para algoritmos de faculdade.

Snippets de C:

Digite o gatilho e pressione `Tab`.

| Digita + Tab | Gera |
| --- | --- |
| `main` | estrutura base |
| `vars` | 3 `int` simples |
| `vars2` / `vars3` / `vars4` / `vars5` | 2 a 5 `int` simples |
| `varshelp` | cola em comentário com formas de declarar variáveis |
| `vi` / `vii` | `int` simples / dois `int` |
| `vf` / `vd` | `float` / `double` |
| `vc` / `vs` | `char` / string `char nome[50]` |
| `lein` / `lef` | lê int/float com validação |
| `fun` / `funv` | função com/sem retorno |
| `funmedia` / `funmaior` | funções prontas |
| `seif` | if / else if / else |
| `paraf` | for com variável sincronizada |
| `dowhile` | do/while |
| `switch` | switch/case com default |
| `menu` | menu interativo completo |
| `media` | média com aprovado/reprovado |
| `areac` / `arear` / `areat` / `areatrap` | áreas de figuras |
| `imc` | IMC com classificação |
| `celsius` | conversão de temperatura |
| `maiorm` | maior entre 3 |
| `vetor` | array completo |
| `struct` / `strucle` | struct + leitura |
| `farq` / `farql` | escrita/leitura de arquivo |
| `pf` / `pfd` / `pff` / `pfs` | printf rápido |

Comandos básicos:

```bash
gcc main.c -Wall -Wextra -std=c11 -g -o main
./main
gdb ./main
valgrind --leak-check=full ./main
```

Com os helpers do `.zshrc`, o mesmo fluxo fica:

| Comando curto | Equivale a |
| --- | --- |
| `cnew` | cria `main.c` básico |
| `cnew aula1` | cria `aula1.c` básico |
| `cmain` | `gcc main.c -Wall -Wextra -std=c11 -g -o main` |
| `run` | compila `main.c` e executa `./main` |
| `cgdb` | `gdb ./main` |
| `cleaks` | `valgrind --leak-check=full ./main` |

Também existem versões flexíveis:

```bash
cbuild programa.c programa
crun programa.c programa
cdebug programa
cleak programa
```

Dentro do Neovim, com um arquivo `.c` aberto:

| Atalho | Ação |
| --- | --- |
| `<Space>rr` | Salva, compila e executa o arquivo C atual |
| `<Space>rc` | Salva e compila o arquivo C atual |
| `<Space>rg` | Salva, compila e abre no `gdb` |
| `<Space>rv` | Salva, compila e roda com `valgrind` |

Exemplo: se o arquivo aberto for `aula1.c`, `<Space>rr` roda algo equivalente a:

```bash
gcc aula1.c -Wall -Wextra -std=c11 -g -o aula1 && ./aula1
```

### Bancada tmux 12/10 para C

A configuração inclui `tmux/tmux.conf` para estudar C em sessões persistentes
com Catppuccin Mocha, status bar com módulos, seletor fuzzy de sessões e
restauração automática. O instalador copia essa configuração para
`~/.tmux.conf`, usando a rota clássica do tmux para reduzir atrito entre Arch,
Ubuntu, TPM e plugins:

```text
janela 1: pensamento / enunciado / anotações
janela 2: NeoVim com o .c
janela 3: terminal para gcc, execução e testes
```

Quando fizer sentido usar painéis na mesma janela:

```text
┌──────────────────────────────┬──────────────────────────────┐
│  raciocinio.md               │  exercicio.c no NeoVim       │
├──────────────────────────────┴──────────────────────────────┤
│  gcc / ./programa / testes / erros                           │
└───────────────────────────────────────────────────────────────┘
```

Plugins do tmux habilitados:

| Plugin | Função |
| --- | --- |
| `tmux-plugins/tpm` | Gerenciador de plugins |
| `tmux-plugins/tmux-sensible` | Padrões básicos bons |
| `christoomey/vim-tmux-navigator` | Navegação contínua entre tmux e NeoVim |
| `tmux-plugins/tmux-resurrect` | Salva e restaura sessões |
| `tmux-plugins/tmux-continuum` | Salva automaticamente a cada 15 minutos e restaura no início |
| `tmux-plugins/tmux-yank` | Copia para o clipboard do sistema |
| `omerxx/tmux-sessionx` | Seletor fuzzy de sessões, janelas e diretórios |
| `alexwforsythe/tmux-which-key` | Menu visual do tmux em `Ctrl+a`, depois `Espaço` |
| `tmux-plugins/tmux-cpu` | CPU/RAM na barra |
| `tmux-plugins/tmux-battery` | Bateria na barra |
| `tmux-plugins/tmux-prefix-highlight` | Indica visualmente quando o prefixo foi pressionado |

O tema `catppuccin/tmux` é instalado manualmente em
`~/.tmux/plugins/catppuccin/tmux`, usando a tag `v2.3.0`, porque o próprio
projeto recomenda esse caminho para evitar conflitos de nome via TPM.

O `tmux-which-key` é configurado como prefix-only: `Ctrl+a`, depois `Espaço`
abre o menu visual do tmux, mas `Ctrl+Space` continua livre para NeoVim,
autocomplete e qualquer outro uso dentro do editor.

Ficou de fora de propósito:

- `tmux-fzf`, porque o `sessionx` já cobre seleção fuzzy, preview, criação,
  rename e delete de sessões.

Atalhos principais:

| Ação | Tecla |
| --- | --- |
| Prefixo | `Ctrl+a` |
| Criar janela | `Ctrl+a`, depois `c` |
| Listar janelas | `Ctrl+a`, depois `w` |
| Dividir painel verticalmente | `Ctrl+a`, depois `|` |
| Dividir painel horizontalmente | `Ctrl+a`, depois `-` |
| Navegar entre NeoVim/tmux | `Ctrl+h/j/k/l` |
| Navegar entre painéis com prefixo | `Ctrl+a`, depois `h/j/k/l` |
| Redimensionar painéis | `Ctrl+a`, depois `H/J/K/L` |
| Desanexar sessão | `Ctrl+a`, depois `d` |
| Recarregar config | `Ctrl+a`, depois `r` |
| Instalar plugins | `Ctrl+a`, depois `I` |
| Abrir menu visual | `Ctrl+a`, depois `Espaço` |
| Abrir seletor de sessões | `Ctrl+a`, depois `o` |
| Salvar sessão com resurrect | `Ctrl+a`, depois `Ctrl+s` |
| Restaurar sessão com resurrect | `Ctrl+a`, depois `Ctrl+r` |

Na primeira execução, abra o tmux e instale os plugins do TPM:

```text
Ctrl+a depois I
```

Para projetos com múltiplos arquivos:

```bash
gcc src/*.c -Wall -Wextra -std=c11 -g -o app
./app
```

Se usar CMake:

```bash
cmake -S . -B build
cmake --build build
./build/app
```

### Python

No Neovim:

- `basedpyright` fornece LSP;
- `black` formata;
- `isort` organiza imports;
- `ruff` faz lint.

Fluxo recomendado por projeto:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
```

Com o helper do `.zshrc`:

```bash
venv
```

Para criar um arquivo Python inicial:

```bash
pynew
pynew exercicio
```

Se existir `requirements.txt`:

```bash
pip install -r requirements.txt
```

Executar:

```bash
python main.py
```

### HTML, CSS e JavaScript

No Neovim:

- `html`, `cssls` e `ts_ls` dão LSP;
- `prettier` formata HTML, CSS, JS, JSON, YAML e Markdown;
- `eslint_d` faz lint de JavaScript/TypeScript quando o projeto tem ESLint.

Projeto simples:

```bash
webnew site
cd site
nvim .
```

O comando `webnew site` cria:

```text
site/
├── index.html
├── style.css
└── script.js
```

Projeto com Node:

```bash
npm init -y
npm install --save-dev prettier eslint
```

Rodar um servidor local simples:

```bash
python -m http.server 8000
```

Depois abra `http://localhost:8000` no navegador.

Com o helper do `.zshrc`:

```bash
server
```

Para outra porta:

```bash
serve 3000
```

### Extras: Kotlin, FastAPI, Docker e Banco

Os arquivos de `vim/files.1.3/` adicionam suporte para uma stack mais ampla:

- Kotlin/Android;
- FastAPI/Python backend;
- Docker Compose;
- PostgreSQL/SQL via `vim-dadbod`;
- TOML, Dockerfile e SQL com LSP/formatadores.

Atalhos novos:

| Atalho | Ação |
| --- | --- |
| `<Space>kk` | Kotlin: compila e roda arquivo `.kt` atual |
| `<Space>kg` | Kotlin/Gradle: `gradle run` ou `./gradlew run` |
| `<Space>kt` | Kotlin/Gradle: `gradle test` ou `./gradlew test` |
| `<Space>fa` | FastAPI: roda `uvicorn main:app --reload` |
| `<Space>fp` | FastAPI: roda `python -m pytest -v` |
| `<Space>Du` | Docker: `docker compose up` |
| `<Space>Dd` | Docker: `docker compose down` |
| `<Space>Dl` | Docker: `docker compose logs -f` |
| `<Space>Dp` | PostgreSQL: abre `psql` |
| `<Space>Db` | Database: abre DBUI |
| `<Space>Da` | Database: adiciona conexão |

Usei `<Space>D...` para Docker/Database para não conflitar com os atalhos do
debugger, que usam `<Space>d...`.

## Estrutura

```text
.
├── install.sh
├── install-extras.sh
├── README.md
├── .zshrc
├── tmux/
│   └── tmux.conf
└── nvim/
    ├── init.lua
    ├── after/
    │   └── syntax/
    │       └── portugol.vim
    └── lua/
        ├── core/
        │   ├── options.lua
        │   ├── keymaps.lua
        │   └── autocmds.lua
        └── plugins/
            ├── ui.lua
            ├── telescope.lua
            ├── treesitter.lua
            ├── lsp.lua
            ├── completion.lua
            ├── database.lua
            ├── editor.lua
            ├── formatting.lua
            ├── git.lua
            ├── kotlin.lua
            ├── terminal.lua
            ├── tmux.lua
            └── debug.lua
```

## Core

### `nvim/init.lua`

É o arquivo que o Neovim executa primeiro.

Ele carrega:

- `core.options`: opções gerais do editor;
- `core.keymaps`: atalhos globais;
- `core.autocmds`: automações;
- `lazy.nvim`: gerenciador de plugins.

Também desativa alguns plugins internos do Vim/Neovim para melhorar a
performance:

- `gzip`
- `matchit`
- `matchparen`
- `netrwPlugin`
- `tarPlugin`
- `tohtml`
- `tutor`
- `zipPlugin`

### `lua/core/options.lua`

Define o comportamento base do editor.

Principais escolhas:

- números absolutos e relativos ativados;
- linha atual destacada;
- coluna de sinais sempre visível;
- régua visual em 100 colunas;
- tema true color com `termguicolors`;
- sem quebra automática de linha por padrão;
- indentação base com 4 espaços;
- busca inteligente com `ignorecase` e `smartcase`;
- sem swapfile e sem backup;
- undo persistente em `stdpath("data")/undodir`;
- splits abrindo abaixo e à direita;
- clipboard integrado ao sistema com `unnamedplus`;
- mouse ativado;
- folds via Treesitter, mas começando expandidos.

### `lua/core/keymaps.lua`

Define atalhos globais. A tecla líder é:

```text
<Space>
```

O arquivo também cria uma função local `map()` para deixar os mapeamentos mais
curtos e sempre silenciosos por padrão.

Atalhos importantes:

| Tecla | Ação |
| --- | --- |
| `<Space>?` | Mostra atalhos no which-key |
| `<C-d>` | Desce meia tela e centraliza |
| `<C-u>` | Sobe meia tela e centraliza |
| `n` / `N` | Próximo/anterior resultado de busca e centraliza |
| `<C-h/j/k/l>` | Navega entre splits e painéis do tmux |
| `<C-Up/Down/Left/Right>` | Redimensiona splits |
| `<S-l>` / `<S-h>` | Próximo/anterior buffer |
| `<Space>bd` | Fecha buffer |
| `<Space>bD` | Força fechar buffer |
| `<A-j>` / `<A-k>` | Move seleção para baixo/cima |
| `<Space>p` em visual | Cola sem sobrescrever clipboard |
| `<Space>y` | Copia para clipboard do sistema |
| `<Space>d` | Deleta sem mandar para clipboard |
| `<Space>rw` | Renomeia palavra no arquivo inteiro |
| `<Esc>` | Limpa destaque de busca |
| `<Space>w` | Salva |
| `<Space>q` | Fecha janela |
| `<Space>Q` | Fecha tudo |
| `<Space>,` | Abre o `init.lua` |
| `<Space>sv` | Split vertical |
| `<Space>sh` | Split horizontal |
| `<Space>se` | Equaliza splits |
| `<Space>sx` | Fecha split |
| `jk` / `kj` | Sai do insert mode |
| `<C-s>` em insert | Salva |
| `<Space>L` | Abre Lazy |
| `<Space>M` | Abre Mason |
| `<Space>Lu` | Atualiza plugins |

### `lua/core/autocmds.lua`

Define automações do editor:

- destaca texto copiado por 150ms;
- remove espaços no fim das linhas ao salvar;
- volta para a última posição ao reabrir arquivo;
- ativa wrap e spellcheck em Markdown, TXT e mensagens de commit;
- usa indentação de 2 espaços em HTML, CSS, JS, TS, JSON, YAML e Lua;
- detecta Portugol em arquivos `.por`, `.portugol` e `.alg`;
- permite fechar janelas auxiliares com `q`;
- recarrega arquivos alterados fora do Neovim.

## Plugins

Todos os arquivos em `nvim/lua/plugins/` retornam uma tabela de especificações
para o `lazy.nvim`.

Cada plugin pode usar campos como:

- `event`: carrega o plugin quando um evento acontece;
- `cmd`: carrega quando um comando é executado;
- `keys`: carrega quando uma tecla mapeada é usada;
- `dependencies`: plugins necessários;
- `opts`: opções passadas automaticamente pelo Lazy;
- `config`: função manual de configuração.

Importante: nem todo plugin usa `setup()`. Alguns usam outro método. Exemplo:
`RRethy/vim-illuminate` usa `configure(opts)`, então a configuração chama isso
manualmente:

```lua
config = function(_, opts)
    require("illuminate").configure(opts)
end
```

### `plugins/ui.lua`

Cuida da aparência e da interface.

Plugins principais:

- `catppuccin/nvim`: tema principal, sabor `mocha`;
- `nvim-lualine/lualine.nvim`: statusline;
- `akinsho/bufferline.nvim`: abas de buffers;
- `nvim-tree/nvim-tree.lua`: explorador de arquivos;
- `goolord/alpha-nvim`: tela inicial;
- `folke/which-key.nvim`: menu de atalhos;
- `folke/noice.nvim`: UI melhor para comandos, mensagens e LSP;
- `rcarriga/nvim-notify`: notificações;
- `lukas-reineke/indent-blankline.nvim`: guias de indentação;
- `NvChad/nvim-colorizer.lua`: mostra cores inline;
- `folke/todo-comments.nvim`: destaca `TODO`, `FIXME`, etc.;
- `stevearc/dressing.nvim`: melhora prompts/selects;
- `RRethy/vim-illuminate`: destaca outras ocorrências da palavra atual;
- `folke/persistence.nvim`: sessões;
- `karb94/neoscroll.nvim`: scroll suave.

Atalho importante:

| Tecla | Ação |
| --- | --- |
| `<Space>e` | Abre/fecha NvimTree |

### `plugins/telescope.lua`

Configura o Telescope, ferramenta de busca.

Ele carrega no `VimEnter` para estar disponível no dashboard.

Extensões usadas:

- `telescope-fzf-native.nvim`, se `make` estiver disponível;
- `telescope-ui-select.nvim`;
- `nvim-web-devicons`.

Atalhos de navegação dentro do Telescope:

| Tecla | Ação |
| --- | --- |
| `<C-j>` | Próximo item |
| `<C-k>` | Item anterior |
| `<Esc>` | Fecha |

### `plugins/treesitter.lua`

Configura Treesitter para highlight, indentação e seleção incremental.

Linguagens instaladas automaticamente:

- Bash
- C
- C++
- HTML
- JavaScript
- JSON
- Lua
- Markdown
- Markdown inline
- Python
- Query
- Regex
- TypeScript
- Vim
- Vimdoc
- YAML

Atalhos de seleção incremental:

| Tecla | Ação |
| --- | --- |
| `<C-Space>` | Inicia/expande seleção |
| `<Backspace>` | Reduz seleção |

### `plugins/lsp.lua`

Configura LSP, ou seja, inteligência de código:

- erros em tempo real;
- ir para definição;
- referências;
- hover de documentação;
- rename;
- code actions;
- formatação via LSP quando aplicável.

Usa:

- `williamboman/mason.nvim`;
- `williamboman/mason-lspconfig.nvim`;
- `neovim/nvim-lspconfig`;
- `b0o/SchemaStore.nvim`;
- `folke/trouble.nvim`;
- `p00f/clangd_extensions.nvim`.

Servidores instalados automaticamente:

| Linguagem | Servidor |
| --- | --- |
| C/C++ | `clangd` |
| Python | `basedpyright` |
| Lua | `lua_ls` |
| TypeScript/JavaScript | `ts_ls` |
| HTML | `html` |
| CSS | `cssls` |
| JSON | `jsonls` |
| YAML | `yamlls` |
| Bash | `bashls` |
| Markdown | `marksman` |

Atalhos LSP:

| Tecla | Ação |
| --- | --- |
| `gd` | Ir para definição |
| `gD` | Ir para declaração |
| `gi` | Ir para implementação |
| `gt` | Ir para definição de tipo |
| `gr` | Ver referências no Telescope |
| `K` | Hover/documentação |
| `<C-k>` | Signature help |
| `<Space>ca` | Code action |
| `<Space>rn` | Renomear símbolo |
| `<Space>cf` | Formatar arquivo |
| `[d` | Diagnóstico anterior |
| `]d` | Próximo diagnóstico |
| `<Space>cd` | Abrir diagnóstico flutuante |
| `<Space>cl` | Lista de diagnósticos |

Atalhos do Trouble:

| Tecla | Ação |
| --- | --- |
| `<Space>xx` | Diagnósticos do projeto |
| `<Space>xX` | Diagnósticos do arquivo |
| `<Space>xq` | Quickfix |

### `plugins/completion.lua`

Configura autocomplete com `nvim-cmp`.

Fontes de autocomplete:

- LSP;
- snippets;
- buffer atual;
- caminhos de arquivos;
- linha de comando;
- busca `/`.

Plugins:

- `hrsh7th/nvim-cmp`;
- `hrsh7th/cmp-nvim-lsp`;
- `hrsh7th/cmp-buffer`;
- `hrsh7th/cmp-path`;
- `hrsh7th/cmp-cmdline`;
- `L3MON4D3/LuaSnip`;
- `rafamadriz/friendly-snippets`;
- `saadparwaiz1/cmp_luasnip`;
- `onsails/lspkind.nvim`.

Atalhos no menu de autocomplete:

| Tecla | Ação |
| --- | --- |
| `<C-j>` | Próxima sugestão |
| `<C-k>` | Sugestão anterior |
| `<C-b>` | Sobe documentação |
| `<C-f>` | Desce documentação |
| `<C-Space>` | Abre autocomplete |
| `<C-e>` | Fecha autocomplete |
| `<CR>` | Confirma sugestão |
| `<Tab>` | Próximo item ou próximo campo do snippet |
| `<S-Tab>` | Item anterior ou campo anterior do snippet |

### `plugins/editor.lua`

Melhora a edição diária.

Plugins:

- `windwp/nvim-autopairs`: fecha parênteses, colchetes e aspas;
- `kylechui/nvim-surround`: adiciona/remove/troca delimitadores;
- `numToStr/Comment.nvim`: comenta código;
- `folke/flash.nvim`: navegação rápida pela tela;
- `echasnovski/mini.ai`: text objects extras;
- `tpope/vim-sleuth`: detecta indentação do projeto;
- `nvim-pack/nvim-spectre`: busca e substitui em múltiplos arquivos;
- `max397574/better-escape.nvim`: melhora saída do insert mode com `jk`;
- `mbbill/undotree`: visualiza histórico de undo;
- `gbprod/yanky.nvim`: histórico de clipboard.

Atalhos úteis:

| Tecla | Ação |
| --- | --- |
| `gcc` | Comenta/descomenta linha |
| `gc` em visual | Comenta/descomenta seleção |
| `gbc` | Comentário de bloco |
| `s` | Flash jump |
| `S` | Flash Treesitter |
| `<Space>S` | Abre Spectre |
| `<Space>sw` | Spectre com palavra sob cursor |
| `<Space>sf` | Spectre no arquivo atual |
| `<Space>u` | Abre Undotree |
| `<C-p>` / `<C-n>` | Navega histórico do Yanky |

Exemplos de `nvim-surround`:

```text
ysiw"   adiciona aspas ao redor da palavra
ysiw(   adiciona parênteses ao redor da palavra
ds"     remove aspas ao redor
cs"'    troca aspas duplas por simples
```

### `plugins/formatting.lua`

Configura formatação e linting.

Usa:

- `stevearc/conform.nvim` para formatação;
- `mfussenegger/nvim-lint` para lint;
- `WhoIsSethDaniel/mason-tool-installer.nvim` para instalar ferramentas.

Formatters por linguagem:

| Linguagem | Formatter |
| --- | --- |
| Lua | `stylua` |
| Python | `isort`, `black` |
| JavaScript | `prettier` |
| TypeScript | `prettier` |
| HTML | `prettier` |
| CSS | `prettier` |
| JSON | `prettier` |
| YAML | `prettier` |
| Markdown | `prettier` |
| C | `clang_format` |
| C++ | `clang_format` |
| Bash/Sh | `shfmt` |

Linters:

| Linguagem | Linter |
| --- | --- |
| Python | `ruff` |
| JavaScript | `eslint_d` |
| TypeScript | `eslint_d` |
| Bash/Sh | `shellcheck` |

Atalhos:

| Tecla | Ação |
| --- | --- |
| `<Space>cf` | Formata arquivo ou seleção |
| `<Space>cl` | Roda linter |

Também há formatação automática ao salvar, com fallback para LSP.

### `plugins/git.lua`

Integra Git ao Neovim.

Plugins:

- `lewis6991/gitsigns.nvim`: sinais de mudanças na lateral;
- `kdheepak/lazygit.nvim`: LazyGit dentro do Neovim;
- `sindrets/diffview.nvim`: visualização de diffs e histórico.

Atalhos:

| Tecla | Ação |
| --- | --- |
| `]h` | Próximo hunk |
| `[h` | Hunk anterior |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hS` | Stage arquivo todo |
| `<Space>hR` | Reset arquivo todo |
| `<Space>hu` | Desfaz stage de hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame da linha |
| `<Space>hd` | Diff do arquivo |
| `<Space>hD` | Diff contra `HEAD~1` |
| `<Space>tb` | Liga/desliga blame inline |
| `<Space>lg` | Abre LazyGit |
| `<Space>gd` | Abre diff do projeto |
| `<Space>gh` | Histórico do arquivo |
| `<Space>gH` | Histórico do projeto |
| `<Space>gx` | Fecha Diffview |

### `plugins/terminal.lua`

Configura terminais com `akinsho/toggleterm.nvim`.

Atalhos:

| Tecla | Ação |
| --- | --- |
| `<C-\>` | Terminal flutuante |
| `<Space>th` | Terminal horizontal |
| `<Space>tv` | Terminal vertical |
| `<Space>tn` | Novo terminal numerado |
| `<Space>rr` | C: compila e roda arquivo atual |
| `<Space>rc` | C: compila arquivo atual |
| `<Space>rg` | C: compila e abre gdb |
| `<Space>rv` | C: compila e roda valgrind |
| `<Esc><Esc>` | Sai do modo terminal |

Dentro do terminal, também é possível navegar para splits do NeoVim e painéis
do tmux com:

| Tecla | Ação |
| --- | --- |
| `<C-h>` | Vai para tmux/split à esquerda |
| `<C-j>` | Vai para tmux/split abaixo |
| `<C-k>` | Vai para tmux/split acima |
| `<C-l>` | Vai para tmux/split à direita |

### `plugins/tmux.lua`

Integra o plugin `christoomey/vim-tmux-navigator` no lado do NeoVim. Isso faz
`<C-h/j/k/l>` atravessar splits do editor e painéis do tmux com a mesma lógica.

### `plugins/debug.lua`

Configura debugger via DAP.

Plugins:

- `mfussenegger/nvim-dap`;
- `rcarriga/nvim-dap-ui`;
- `mfussenegger/nvim-dap-python`;
- `jay-babu/mason-nvim-dap.nvim`;
- `nvim-neotest/nvim-nio`.

Adapters instalados automaticamente:

- `debugpy`, para Python;
- `codelldb`, para C/C++/Rust.

Atalhos:

| Tecla | Ação |
| --- | --- |
| `<F5>` | Inicia/continua |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Space>db` | Toggle breakpoint |
| `<Space>dB` | Breakpoint condicional |
| `<Space>dr` | Abre REPL |
| `<Space>dl` | Roda última sessão |
| `<Space>dx` | Encerra debug |
| `<Space>du` | Abre/fecha UI do debugger |
| `<Space>dm` | Testa método Python |
| `<Space>dc` | Testa classe Python |

## Portugol

Arquivos com extensão:

- `.por`
- `.portugol`
- `.alg`

são detectados como `filetype=portugol`.

A sintaxe fica em:

```text
nvim/after/syntax/portugol.vim
```

Ela destaca:

- palavras-chave;
- tipos;
- operadores;
- strings;
- números;
- comentários;
- funções matemáticas comuns.

## Comandos Úteis

Dentro do Neovim:

| Comando | Uso |
| --- | --- |
| `:Lazy` | Abre gerenciador de plugins |
| `:Lazy update` | Atualiza plugins |
| `:Lazy sync` | Sincroniza plugins |
| `:Mason` | Abre instalador de LSPs/formatters/linters |
| `:MasonUpdate` | Atualiza registro do Mason |
| `:LspInfo` | Mostra LSPs ativos no buffer |
| `:ConformInfo` | Mostra informações de formatação |
| `:checkhealth` | Diagnóstico geral do Neovim |
| `:TSUpdate` | Atualiza parsers do Treesitter |

No terminal:

```bash
nvim --headless '+qa'
```

Esse comando testa se a configuração carrega sem abrir a interface.

Para testar um plugin específico:

```bash
nvim --headless '+Lazy! load vim-illuminate' '+qa'
```

## Como Alterar a Configuração

Para mudar opções do editor:

```text
nvim/lua/core/options.lua
```

Para mudar atalhos globais:

```text
nvim/lua/core/keymaps.lua
```

Para mudar automações:

```text
nvim/lua/core/autocmds.lua
```

Para adicionar/remover plugins:

```text
nvim/lua/plugins/
```

Regra prática:

- aparência vai em `plugins/ui.lua`;
- busca vai em `plugins/telescope.lua`;
- LSP vai em `plugins/lsp.lua`;
- autocomplete vai em `plugins/completion.lua`;
- edição vai em `plugins/editor.lua`;
- formatação/lint vai em `plugins/formatting.lua`;
- Git vai em `plugins/git.lua`;
- terminal vai em `plugins/terminal.lua`;
- debugger vai em `plugins/debug.lua`.

## Como Adicionar um Plugin

Crie ou edite um arquivo em `nvim/lua/plugins/`.

Exemplo simples:

```lua
return {
    {
        "autor/plugin.nvim",
        event = "BufReadPost",
        opts = {},
    },
}
```

Se o plugin usa `setup(opts)`, `opts = {}` geralmente basta.

Se o plugin não usa `setup`, configure manualmente:

```lua
return {
    {
        "autor/plugin.nvim",
        event = "BufReadPost",
        opts = {},
        config = function(_, opts)
            require("plugin").configure(opts)
        end,
    },
}
```

Essa diferença é importante porque o `lazy.nvim` chama `setup()` automaticamente
quando existe `opts` e não existe `config` customizado.

## Manutenção

Rotina recomendada:

```vim
:Lazy sync
:Mason
:checkhealth
```

Depois de alterar arquivos Lua:

```bash
nvim --headless '+qa'
```

Se algo quebrar, abra:

```vim
:messages
:Lazy
:checkhealth
```

## Problemas Comuns

### Erro `attempt to call field 'setup'`

Significa que algum plugin foi configurado com `opts`, mas não possui função
`setup()`.

Solução: usar `config = function(_, opts) ... end` e chamar a função correta do
plugin.

Exemplo real desta configuração:

```lua
{
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
```

### Ícones estranhos ou quadrados

Isso significa que o terminal não está usando uma Nerd Font.

O instalador tenta instalar `JetBrainsMono Nerd Font`. Depois disso, selecione
essa fonte no seu terminal.

No Ubuntu, a forma automatizada é:

```bash
sudo apt-get update
sudo apt-get install -y curl unzip fontconfig
bash install.sh --fonts-only
```

Depois selecione no terminal:

```text
JetBrainsMono Nerd Font Mono
```

No Konsole, comum em KDE/EndeavourOS:

1. Abra o Konsole.
2. Vá em `Configurações`.
3. Abra `Gerenciar perfis`.
4. Edite o perfil atual.
5. Vá em `Aparência`.
6. Escolha `JetBrainsMono Nerd Font`.
7. Feche e abra o terminal de novo.

Para verificar se alguma Nerd Font existe:

```bash
fc-list | grep -i "Nerd Font"
```

Se os ícones ainda aparecerem como quadrados, o problema quase sempre é o perfil
do terminal ainda usando fonte comum, como `Hack`, `Monospace` ou `DejaVu Sans
Mono`.

### LSP não funciona

Verifique:

```vim
:Mason
:LspInfo
:checkhealth vim.lsp
```

Também confirme se abriu um arquivo de uma linguagem suportada.

### Formatação não acontece

Verifique:

```vim
:ConformInfo
:Mason
```

O formatter precisa estar instalado e associado ao filetype correto.

### Telescope não encontra texto

Instale `ripgrep`.

```bash
rg --version
```

### LazyGit não abre

Instale `lazygit`.

```bash
lazygit --version
```

## Filosofia da Configuração

A configuração tenta equilibrar três coisas:

- carregar rápido;
- ter ferramentas modernas de IDE;
- manter os arquivos organizados por responsabilidade.

O `core/` fica para comportamento básico do editor.

O `plugins/` fica para funcionalidades extras, separadas por área.

Essa divisão evita que o `init.lua` vire um arquivo gigante e facilita entender
onde mexer quando algo precisa mudar.
