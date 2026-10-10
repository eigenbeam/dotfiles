# Emacs

> "Emacs outshines all other editing software in approximately the same way
> that the noonday sun does the stars." — Neal Stephenson

Emacs 31 (`emacs-plus-app` cask), built-ins first, a small set of
well-adopted packages on top. Dark Gruvbox like the rest of the dotfiles.

## Layout

| File | Role |
|---|---|
| `early-init.el` | Startup GC, native-comp cache under `var/`, frame defaults |
| `init.el` | package.el + MELPA, built-in `use-package`, loads the modules below |
| `lisp/basics.el` | no-littering (first), defaults, vertico/consult/orderless/marginalia |
| `lisp/theme.el` | Per-monitor font sizing, Nerd glyph fontset, mood-line, gruvbox-dark-hard |
| `lisp/packages.el` | Editing, vterm, built-in tree-sitter, corfu/cape, embark, magit, project.el, Claude Code |
| `lisp/dev.el` | eglot, apheleia, flymake-ruff, envrc, dape, Julia |
| `lisp/org-config.el` | org, org-modern, org-appear |

Runtime state goes to `var/` and generated config (including `custom.el`) to
`etc/`; both are gitignored, as are `elpa/`, `eln-cache/`, `tree-sitter/`,
and `debug-adapters/`.

## First launch

1. `brew bundle --file homebrew/Brewfile` (vterm needs `cmake` and `libvterm`).
2. Start Emacs. Packages install from MELPA/ELPA; `claude-code-ide` is cloned
   from GitHub with package-vc.
3. Open a file in each language once. Tree-sitter grammars compile on first
   use (`treesit-auto-install-grammar` is `always`; needs git + clang).
4. Julia: the first `eglot` in a `.jl` buffer downloads and precompiles
   LanguageServer.jl into its own depot environment. Expect a minute or two;
   progress is in `*EGLOT ... stderr*`.

Update later with `M-x package-upgrade-all` and `M-x package-vc-upgrade`.

## Keys

| Key | Action |
|---|---|
| `M-o` | ace-window |
| `C-x b` / `C-x p b` | consult-buffer / project buffers |
| `M-s r` / `M-s l` | ripgrep project / search lines |
| `M-g g` / `M-g i` / `M-g f` | goto line / imenu / flymake list |
| `M-g n` / `M-g p` | next / previous diagnostic |
| `C-.` / `C-;` | embark act / dwim |
| `C-x u` | vundo |
| `M-n` / `M-p` | open indented line below / above |
| `C->` / `C-<` / `C-S-c C-S-c` | multiple cursors |
| `C-c p ...` | project.el map (`f` find file, `g` grep, `s` shell, `e` eshell) |
| `C-c g` | magit-status |
| `C-c t` | vterm |
| `C-c C-'` | Claude Code menu |
| `C-c a` / `C-c c` / `C-c l` (org) | agenda / capture / store link |

LSP (eglot), active in every buffer with a server:

| Key | Action |
|---|---|
| `M-.` / `M-,` / `M-?` | definition / back / references |
| `C-c l r` / `C-c l a` / `C-c l f` | rename / code actions / format |
| `C-c l d` / `C-c l h` | eldoc at point / doc buffer |
| `M-x eglot-inlay-hints-mode` | inlay hints are off by default |

Debugging (dape, `C-c d` prefix; `repeat-mode` means `C-c d n n n` works):

| Key | Action |
|---|---|
| `d` | start (`dape`, prompts for a config name) |
| `b` / `B` / `e` | toggle breakpoint / remove all / expression breakpoint |
| `n` / `s` / `o` / `c` / `p` | next / step in / step out / continue / pause |
| `r` / `q` / `D` | restart / quit / disconnect and quit |
| `i` / `R` / `w` / `x` | info buffers / REPL / watch at point / evaluate |

Format on save is apheleia (`M-x apheleia-mode` to toggle per buffer).

## Languages

| Language | Mode | LSP | Format on save | Debugger |
|---|---|---|---|---|
| C / C++ | `c-ts-mode`, `c++-ts-mode` | clangd (Xcode CLT) | off, like nvim | `lldb-dap` (CLT, found via `xcrun`) |
| Python | `python-ts-mode` | pyright (brew) + ruff diagnostics | ruff | `debugpy`: `uv add --dev debugpy` |
| Java | `java-ts-mode` | jdtls (brew) | off | not wired (needs the java-debug bundle in jdtls init) |
| JS / TS | `js-ts-mode`, `typescript-ts-mode`, `tsx-ts-mode` | typescript-language-server (`make tools`) | prettier | `js-debug-node` (download below) |
| Julia | `julia-mode` | LanguageServer.jl via eglot-jl | off | none; REPL: `C-c C-z`, send region `C-c C-c` (julia-repl in vterm) |
| Shell | `bash-ts-mode` | bash-language-server (brew) | off | |
| JSON / YAML / TOML / Markdown / Terraform | ts modes, markdown-mode, terraform-mode | | prettier / prettier / taplo / prettier / terraform fmt | |
| Mathematica | not configured | | | |

clangd needs a `compile_commands.json`: `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
or `bear -- make`.

JS debugging, one-time: download `js-debug-dap-v*.tar.gz` from
<https://github.com/microsoft/vscode-js-debug/releases> and extract it so that
`~/.emacs.d/debug-adapters/js-debug/src/dapDebugServer.js` exists.

Per-project environment (`.venv`, `node_modules/.bin`, secrets) comes from
`.envrc` via direnv (envrc package). pyright finds `.venv` on its own.

## Claude Code

`claude-code-ide` runs the Claude Code CLI in vterm and exposes Emacs to Claude
over MCP: the current selection, xref, flymake diagnostics, imenu/tree-sitter,
project info. Proposed edits open in ediff (side by side, same frame); edit
buffer B, then accept or reject. `C-c C-'` is the menu: start, send prompt,
continue, resume, toggle window, list sessions. One instance per project.

Division of labor: tmux Claude for long autonomous runs; in-Emacs Claude when
the Emacs context pays off (tight edit-review loops, "fix the diagnostic at
point", selection-based questions). The two are separate processes.

Supporting settings: `global-auto-revert-mode` reloads files Claude edits,
`SSH_AUTH_SOCK` is imported so magit can push from a Dock-launched Emacs, and
`.claude/` is gitignored here. `ghostel` (libghostty) is the backend upstream
recommends; switch with `claude-code-ide-terminal-backend` once vterm works.

## Theme

`gruvbox-dark-hard` (`lisp/theme.el`). If light text smears, try
`gruvbox-dark-soft`. The built-in `modus-vivendi` / `modus-operandi` are a
`M-x load-theme` away for a high-contrast day.

## Troubleshooting

- **No syntax highlighting / `*-ts-mode` fails**: grammar did not compile.
  `M-x treesit-install-language-grammar`, and check git and clang are on PATH.
- **eglot does not start**: `M-x eglot` reports the missing server binary.
  GUI-launched Emacs gets PATH from a login shell via exec-path-from-shell.
- **vterm "module not found"**: install `cmake` and `libvterm`, then answer
  yes to the compile prompt on the next `C-c t`.
- **Startup warnings**: `*Warnings*` is deliberately not hidden. Package
  install 404s self-heal once by refreshing the archive index (`init.el`).
