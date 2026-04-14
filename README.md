# nvim config

A personal Neovim configuration built around [lazy.nvim](https://github.com/folke/lazy.nvim), targeting Rust, Godot, web, Python, and LaTeX development.

## Requirements

### Core

- Neovim >= 0.10
- Git
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal

### Build / language toolchains

- `node` / `npm` — required by several LSP servers
- `rust-analyzer` — Rust LSP (installed via rustup, not Mason)
- `latexmk` — LaTeX compiler (used by vimtex)
- TeX distribution with at least one of `xelatex`, `lualatex`, `pdflatex` — required for Markdown → PDF via pandoc

### External tools launched from within Neovim

| Tool                                                  | Used for                                                                                                 |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [`lazygit`](https://github.com/jesseduffield/lazygit) | Full-screen Git TUI (`<leader>tg`)                                                                       |
| [`btm`](https://github.com/ClementTsang/bottom)       | System monitor TUI (`<leader>tb`)                                                                        |
| [`claude`](https://github.com/anthropics/claude-code) | Claude Code CLI (claudecode.nvim integration)                                                            |
| [`gh`](https://cli.github.com/)                       | GitHub issues/PRs on dashboard (optional)                                                                |
| [`glab`](https://gitlab.com/gitlab-org/cli)           | GitLab issues/MRs on dashboard (optional)                                                                |
| [Skim](https://skim-app.sourceforge.io/)              | PDF preview for LaTeX and Markdown on macOS; falls back to system viewer (Preview) if missing (optional) |
| [`pandoc`](https://pandoc.org/)                       | Markdown → PDF conversion                                                                                |

### Formatters / linters (installed by Mason or manually)

| Tool       | Language(s)                       |
| ---------- | --------------------------------- |
| `prettier` | JS/TS/CSS/HTML/JSON/YAML/Markdown |
| `eslint_d` | JavaScript / TypeScript           |
| `black`    | Python                            |
| `isort`    | Python                            |
| `stylua`   | Lua                               |
| `ast-grep` | Lua                               |
| `clangd`   | C / C++                           |

## Installation

```bash
# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/Mitra98t/miravim.git ~/.config/nvim
nvim
```

lazy.nvim will bootstrap itself and install all plugins on the first launch.

## Structure

```
~/.config/nvim/
├── init.lua                   # Entry point
├── lua/
│   ├── config/
│   │   └── lazy.lua           # lazy.nvim bootstrap
│   ├── core/
│   │   ├── init.lua
│   │   ├── options.lua        # Vim options
│   │   ├── keymaps.lua        # Custom keymaps (LSP symbol navigation)
│   │   └── ui.lua
│   ├── plugins/
│   │   ├── lsp/
│   │   │   └── lspconfig.lua  # Mason + LSP setup
│   │   └── *.lua              # One file per plugin
│   ├── private_plugin/        # User-local plugin specs (ignored by git, auto-imported if present)
│   └── snippets/              # Custom snippets
└── after/
```

`lua/private_plugin/` is intentionally gitignored so each user can keep personal plugins and machine-specific settings without polluting the shared repository.

## Features

### UI

| Plugin                                                              | Purpose                                                                                                                                             |
| ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| [snacks.nvim](https://github.com/folke/snacks.nvim)                 | All-in-one utility: dashboard, file explorer, fuzzy picker, zen mode, notifications, image preview, indent guides, buffer scroll, word highlighting |
| [noice.nvim](https://github.com/folke/noice.nvim)                   | Replaces the default cmdline, messages panel, and LSP hover/signature UI with styled floating windows                                               |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)        | Statusline with kaomoji mode indicators (see below)                                                                                                 |
| [which-key.nvim](https://github.com/folke/which-key.nvim)           | Popup keybinding hints on `<leader>` and other prefixes                                                                                             |
| [barbecue.nvim](https://github.com/utilyre/barbecue.nvim)           | Winbar breadcrumbs showing the LSP symbol path to the cursor                                                                                        |
| [neominimap.nvim](https://github.com/Isrothy/neominimap.nvim)       | Code minimap shown in a side window, with per-window/tab/buffer controls                                                                            |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File-type icons used throughout the UI                                                                                                              |

The statusline uses kaomoji to show the current mode:

| Mode              | Kaomoji     |
| ----------------- | ----------- |
| Normal            | `(ᴗ_ ᴗ。)`  |
| Insert            | `(•̀ - •́ )`  |
| Visual            | `(⊙ _ ⊙ )`  |
| Replace           | `( •̯́ ₃ •̯̀)`  |
| Command / pending | `Σ(°△°ꪱꪱꪱ)` |
| Terminal          | `(⌐■_■)`    |

### Colorschemes

13 themes bundled and selectable at runtime via `<leader>ut`. The chosen theme persists across sessions via an auto-generated `lua/core/colorscheme_percist.lua`.

Themes: miasma · gruvbox · vague · catppuccin · rose-pine · nord · everforest · tokyonight · kanagawa · ayu · darkplus · eldritch · nordic

### LSP & Completion

| Plugin                                                                                    | Purpose                                                       |
| ----------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                                  | GUI package manager for LSP servers, linters, and formatters  |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)              | Bridges Mason with nvim-lspconfig                             |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Auto-installs `prettier`, `clangd`, `eslint_d` on startup     |
| [blink.cmp](https://github.com/Saghen/blink.cmp)                                          | Completion engine with LSP, buffer, path, and snippet sources |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                | LSP client configurations                                     |
| [inlay-hints](https://github.com/MysticalDevil/inlay-hints.nvim)                          | Toggleable LSP inlay hints                                    |

### Language Support

| Language                    | Tooling                                                                                                                                                             |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Rust**                    | [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) — run, debug, test via `<leader>c*` prompts; uses rust-analyzer                                              |
| **Godot / GDScript**        | LSP auto-started when `project.godot` is detected; DAP connects to Godot editor on `localhost:6006`                                                                 |
| **JavaScript / TypeScript** | LSP + prettier + eslint_d; auto-tag closing via nvim-ts-autotag                                                                                                     |
| **Python**                  | LSP + black + isort                                                                                                                                                 |
| **LaTeX**                   | [vimtex](https://github.com/lervag/vimtex) + Skim viewer (falls back to system default if Skim is absent); auto-detects `main.tex` by walking up the directory tree |
| **C / C++**                 | clangd (via Mason)                                                                                                                                                  |
| **Lua**                     | stylua + ast-grep                                                                                                                                                   |
| **Love2D**                  | [love2d.nvim](https://github.com/S1M0N38/love2d.nvim) — run and manage Love2D projects                                                                              |

### Formatting

[conform.nvim](https://github.com/stevearc/conform.nvim) formats on save for all supported filetypes. Manual format: `<leader>cf`.

### Debugging

[nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui). The UI opens/closes automatically on session start/stop. Godot debug adapter connects to the running editor instance.

### AI

| Plugin                                                      | Notes                                                                                                   |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Integrates the Claude Code CLI: toggle/focus the terminal, send selections, manage diffs (`<leader>a*`) |
| [copilot.vim](https://github.com/github/copilot.vim)        | Inline ghost-text completions — loaded but **disabled by default**                                      |

### Git

| Plugin                                                       | Notes                                                                   |
| ------------------------------------------------------------ | ----------------------------------------------------------------------- |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)  | Hunk signs in the gutter, inline blame, hunk preview and navigation     |
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | File and selection diff viewer against any revision; git log explorer   |
| snacks dashboard                                             | Shows open issues, PRs/MRs, git diff stat, and notifications on startup |

### Search & Navigation

| Plugin                                                            | Notes                                                                                                                    |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| [snacks.nvim picker](https://github.com/folke/snacks.nvim)        | Telescope-layout fuzzy finder for files, grep, LSP symbols, buffers, marks, registers, projects, notifications, and more |
| [flash.nvim](https://github.com/folke/flash.nvim)                 | Character-jump navigation with `s` / `S` in normal, visual, and operator-pending modes                                   |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights `TODO`, `FIXME`, `NOTE`, etc. and makes them searchable via `<leader>ft`                                      |

### Other

| Plugin                                                                                     | Notes                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)                              | Floating and persistent terminal windows; pre-configured instances for lazygit and btm                                                                                                 |
| [trouble.nvim](https://github.com/folke/trouble.nvim)                                      | Pretty diagnostics list, LSP references panel, and quickfix integration                                                                                                                |
| [neogen](https://github.com/danymat/neogen)                                                | Generates doc comments (Doxygen-style) for functions and types                                                                                                                         |
| [markview.nvim](https://github.com/OXY2DEV/markview.nvim)                                  | Renders Markdown in-buffer (headings, tables, code blocks) while editing                                                                                                               |
| [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim)                          | Generates and updates a table of contents in Markdown files via `:Mtoc`                                                                                                                |
| Markdown PDF (ftplugin)                                                                    | Converts the current file to PDF via `pandoc` + `xelatex`, previewed in Skim if installed, otherwise system default viewer (macOS only); toggle auto-render on save with `<leader>mmr` |
| [nvim-colorizer](https://github.com/NvChad/nvim-colorizer.lua)                             | Inline color preview for hex codes and CSS color names                                                                                                                                 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                      | Syntax highlighting, indentation, folding, and incremental selection                                                                                                                   |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                               | Auto-closes and renames HTML/JSX tags                                                                                                                                                  |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)                                 | Auto-closes brackets, quotes, and other pairs                                                                                                                                          |
| [fluoride](https://github.com/xero/fluoride.vim)                                           | Miscellaneous utilities                                                                                                                                                                |
| [better-inline-diagnostics](https://github.com/sontungexpt/better-diagnostic-virtual-text) | Improved inline diagnostic display                                                                                                                                                     |

---

## Keymaps

`<leader>` is `<Space>`.

### Global

| Key        | Mode      | Action                                          |
| ---------- | --------- | ----------------------------------------------- |
| `<C-s>`    | n / v / i | Write file (uses `w!` for `.tex` files)         |
| `<C-q>`    | n / v / i | Quit all (`:qall`)                              |
| `<S-Up>`   | v         | Move selection up                               |
| `<S-Down>` | v         | Move selection down                             |
| `gd`       | n         | Go to definition (LSP)                          |
| `gD`       | n         | Go to declaration (LSP)                         |
| `gi`       | n         | Go to implementation (LSP)                      |
| `gr`       | n         | Go to references (LSP)                          |
| `gy`       | n         | Go to type definition (LSP)                     |
| `K`        | n         | Hover documentation (LSP)                       |
| `]]`       | n         | Next LSP document symbol                        |
| `[[`       | n         | Previous LSP document symbol                    |
| `s`        | n / x / o | Flash jump (character-based navigation)         |
| `S`        | n / x / o | Flash Treesitter jump                           |
| `<BS>`     | n         | Start / expand incremental Treesitter selection |
| `<C-BS>`   | n         | Expand selection to scope                       |
| `<M-BS>`   | n         | Shrink incremental selection                    |

### `<leader>a` — AI / Claude Code

| Key                          | Action                                  |
| ---------------------------- | --------------------------------------- |
| `<leader>ac`                 | Toggle Claude Code terminal             |
| `<leader>af`                 | Focus Claude Code terminal              |
| `<leader>ar`                 | Resume last Claude session (`--resume`) |
| `<leader>aC`                 | Continue Claude session (`--continue`)  |
| `<leader>am`                 | Select Claude model                     |
| `<leader>ab`                 | Add current buffer to Claude context    |
| `<leader>as` (v)             | Send visual selection to Claude         |
| `<leader>as` (file explorer) | Add file under cursor to Claude context |
| `<leader>aa`                 | Accept Claude diff                      |
| `<leader>ad`                 | Deny Claude diff                        |

### `<leader>c` — Code

| Key          | Action                                |
| ------------ | ------------------------------------- |
| `<leader>cf` | Format file (or range in visual mode) |
| `<leader>ca` | LSP code action                       |
| `<leader>cr` | LSP rename symbol                     |
| `<leader>cd` | Rust: quick debug (prompts for args)  |
| `<leader>cD` | Rust: debuggables picker              |
| `<leader>cs` | Rust: quick run (prompts for args)    |
| `<leader>cS` | Rust: runnables picker                |
| `<leader>ct` | Rust: testables picker                |

### `<leader>d` — Debugger

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>db` | Toggle breakpoint     |
| `<leader>ds` | Continue              |
| `<leader>dd` | Step into             |
| `<leader>do` | Step over             |
| `<leader>du` | Step out              |
| `<leader>dt` | Terminate session     |
| `<leader>dq` | Close DAP UI          |
| `<leader>dp` | Set log-point message |

### `<leader>e` — Explorer

| Key          | Action                        |
| ------------ | ----------------------------- |
| `<leader>ee` | Toggle file explorer (snacks) |
| `<leader>es` | Symbols panel (Trouble)       |

### `<leader>f` — Find / Picker

| Key                | Mode  | Action                             |
| ------------------ | ----- | ---------------------------------- |
| `<leader><leader>` | n     | Smart file finder                  |
| `<leader>ff`       | n     | Resume last picker search          |
| `<leader>fw`       | n / v | Grep word under cursor / selection |
| `<leader>fW`       | n     | Grep across project (full input)   |
| `<leader>fs`       | n     | LSP symbols                        |
| `<leader>fr`       | n     | LSP references                     |
| `<leader>fb`       | n     | Open buffers                       |
| `<leader>ft`       | n     | TODO comments                      |
| `<leader>fl`       | n     | Lines in current buffer            |
| `<leader>fm`       | n     | Marks                              |
| `<leader>fq`       | n     | Registers                          |
| `<leader>fn`       | n     | Notification history               |
| `<leader>fp`       | n     | Recent projects                    |
| `<leader>fg`       | n     | Git diff hunks                     |
| `<leader>fM`       | n     | Man pages                          |
| `<leader>fx`       | n     | Diagnostics (current buffer)       |
| `<leader>fX`       | n     | Diagnostics (workspace)            |

### `<leader>g` — Git

| Key          | Mode | Action                            |
| ------------ | ---- | --------------------------------- |
| `]c`         | n    | Next hunk                         |
| `[c`         | n    | Previous hunk                     |
| `<leader>gb` | n    | Blame entire file (gitsigns)      |
| `<leader>gg` | n    | Preview hunk (floating)           |
| `<leader>gG` | n    | Preview hunk inline               |
| `<leader>gn` | n    | Next hunk                         |
| `<leader>gN` | n    | Previous hunk                     |
| `<leader>gh` | n    | File diff history (codediff)      |
| `<leader>gh` | v    | Selection diff history            |
| `<leader>gf` | n    | Diff file vs HEAD                 |
| `<leader>gF` | n    | Diff file vs HEAD~1               |
| `<leader>gd` | n    | Git status explorer               |
| `<leader>gH` | n    | Repo commit history               |
| `<leader>gp` | n    | PR diff — prompts for branch name |
| `<leader>gD` | n    | CodeDiff with custom revision     |

### `<leader>l` — Diagnostics

| Key          | Action                        |
| ------------ | ----------------------------- |
| `<leader>ld` | Show line diagnostic (float)  |
| `<leader>ln` | Next diagnostic               |
| `<leader>lr` | Previous diagnostic           |
| `<leader>lc` | Generate doc comment (neogen) |

### `<leader>ml` — LaTeX (VimTeX)

| Key           | Action                 |
| ------------- | ---------------------- |
| `<leader>mlc` | Compile                |
| `<leader>mls` | Stop compiler          |
| `<leader>mlv` | View PDF               |
| `<leader>mlt` | Open table of contents |
| `<leader>mlk` | Clean auxiliary files  |
| `<leader>mlK` | Clean entire project   |
| `<leader>mle` | Show errors            |
| `<leader>mla` | Toggle autosave        |

### `<leader>mm` — Markdown

Renders the current Markdown file to PDF using `pandoc` plus the first available engine among `xelatex` / `lualatex` / `pdflatex`. The PDF is written to a temporary directory and opened with Skim on macOS when available, otherwise with the system default PDF viewer.

| Key           | Action                         |
| ------------- | ------------------------------ |
| `<leader>mmr` | Toggle auto PDF render on save |
| `<leader>mmp` | Render PDF now                 |

### `<leader>t` — Terminal

| Key          | Mode | Action                              |
| ------------ | ---- | ----------------------------------- |
| `<leader>tt` | n    | Open last terminal (toggleterm)     |
| `<leader>tf` | n    | Open floating terminal              |
| `<leader>tg` | n    | Open LazyGit                        |
| `<leader>tb` | n    | Open btm (system monitor)           |
| `<C-w>`      | t    | Switch from terminal to normal mode |

### `<leader>u` — UI

| Key            | Action                           |
| -------------- | -------------------------------- |
| `<leader>ut`   | Theme switcher (live preview)    |
| `<leader>uz`   | Zen mode                         |
| `<leader>use`  | Enable English spellcheck        |
| `<leader>usi`  | Enable Italian spellcheck        |
| `<leader>unm`  | Toggle minimap (global)          |
| `<leader>uno`  | Enable minimap (global)          |
| `<leader>unc`  | Disable minimap (global)         |
| `<leader>unr`  | Refresh minimap (global)         |
| `<leader>unwt` | Toggle minimap (current window)  |
| `<leader>unwr` | Refresh minimap (current window) |
| `<leader>unwo` | Enable minimap (current window)  |
| `<leader>unwc` | Disable minimap (current window) |
| `<leader>untt` | Toggle minimap (current tab)     |
| `<leader>untr` | Refresh minimap (current tab)    |
| `<leader>unto` | Enable minimap (current tab)     |
| `<leader>untc` | Disable minimap (current tab)    |
| `<leader>unbt` | Toggle minimap (current buffer)  |
| `<leader>unbr` | Refresh minimap (current buffer) |
| `<leader>unbo` | Enable minimap (current buffer)  |
| `<leader>unbc` | Disable minimap (current buffer) |
| `<leader>unf`  | Focus minimap                    |
| `<leader>unu`  | Unfocus minimap                  |
| `<leader>uns`  | Toggle minimap focus             |

### `<leader>x` — Trouble / Diagnostics

| Key          | Action                                 |
| ------------ | -------------------------------------- |
| `<leader>xx` | Buffer diagnostics (Trouble)           |
| `<leader>xX` | Workspace diagnostics (Trouble)        |
| `<leader>xr` | LSP definitions / references (Trouble) |
| `<leader>xg` | Quickfix list for git hunks            |
