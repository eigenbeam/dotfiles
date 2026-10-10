# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS and Linux. Config files are managed with [GNU Stow](https://www.gnu.org/software/stow/) using `--dotfiles` mode — files and directories named `dot-*` become `.*` when symlinked. All stow packages target `$HOME`. Package management uses Homebrew on both platforms (Linuxbrew on Linux). The `keyboard` package is macOS-only and automatically skipped on Linux.

Make targets are documented in `README.md`. `make doctor` verifies a machine's setup; `make lint` runs shellcheck on the bash files and a paren check on the Emacs elisp.

## Architecture

**Stow package convention:** Every top-level directory except `homebrew`, `linux`, and `reference-cards` is a stow package (ai, bash, zsh, git, nvim, emacs, ghostty, keyboard, tmux, starship, lazygit, yazi, ssh). Files mirror their target path under `$HOME`. For example, `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`, and `bash/dot-profile` becomes `~/.profile`. `ssh` is stowed only by `make ssh`, never by `make all`.

**Shell layering:**
- `bash/dot-profile` — shared login environment (PATH, Homebrew, Rust, NVM, Java). Sourced by both `.zprofile` and `.bash_profile`.
- `bash/dot-shell-common` — shared interactive config (aliases, FZF vars, NVM lazy-load, yazi `yy` function). Sourced by both `.bashrc` and `.zshrc`.
- `zsh/dot-zshrc` — interactive zsh config (completions, plugins, tool integrations).
- `bash/dot-bashrc` — interactive bash config.

**Neovim** (`nvim/.config/nvim/init.lua`): Single-file config using lazy.nvim. Has a `vim.g.vscode` guard — in VSCode, lazy.nvim and all plugins are skipped entirely (keybindings-only config); otherwise loads the full setup (Telescope, LSP via nvim-lspconfig, blink.cmp, Treesitter, conform, nvim-lint, nvim-dap, gitsigns, smart-splits, etc.). Theme: Gruvbox Dark.

**Emacs** (`emacs/dot-emacs.d/`): Targets the Emacs 31 `emacs-plus-app` cask. `early-init.el` holds startup tuning; `init.el` sets up package.el + built-in `use-package`, then loads `lisp/` modules in order: `basics` (no-littering first, defaults, vertico/consult/orderless/marginalia), `theme` (per-monitor font sizing, mood-line, gruvbox-dark-hard), `packages` (editing, vterm, built-in tree-sitter via `treesit-enabled-modes`, corfu/cape, embark, magit/diff-hl/project.el, claude-code-ide), `dev` (eglot, apheleia format-on-save mirroring nvim's conform table, flymake-ruff, envrc, dape, Julia), `org-config`. Runtime state lives in gitignored `var/` and `etc/` (no-littering; `custom.el` is in `etc/`). `claude-code-ide` is installed with `:vc` from GitHub, not MELPA. Keybindings and per-language toolchain are documented in `emacs/dot-emacs.d/README.md`.

**Tmux ↔ Neovim navigation:** smart-splits.nvim + tmux config use `@pane-is-vim` to seamlessly share `C-h/j/k/l` navigation and `M-h/j/k/l` resizing across nvim splits and tmux panes.

**NVM lazy-loading:** NVM is lazy-loaded in `.shell-common` for startup performance — wrapper functions for `nvm`, `node`, `npm`, `npx` trigger the actual load on first use. `make tools` deliberately uses Homebrew's npm, not nvm's, so globals land on PATH before nvm loads.

**Tmux sessionizer:** `C-a f` opens fzf popup to fuzzy-find `~/projects` directories and create/attach named tmux sessions. Script at `bash/dot-local/bin/tmux-sessionizer`.

**Git config** uses XDG layout (`~/.config/git/`), delta for diffs, and includes `~/.gitconfig-local` for machine-specific overrides. The `make all` target creates this file if missing.

## Conventions

- **Indent:** 4 spaces (2 for YAML). Tabs only in Makefiles. See `.editorconfig`.
- **Line endings:** LF only.
- **Shell linting:** `shellcheck` on bash files (`make lint`). Zsh files are not linted. The same target runs `check-parens` over the Emacs elisp; it deliberately does not byte-compile, because expanding the `:vc` use-package form installs packages.
- **Neovim formatting:** conform.nvim with stylua (Lua), ruff (Python), prettier (JS/TS/JSON/YAML/MD), terraform_fmt, taplo (TOML). Format-on-save is enabled.
- **Dark theme throughout:** Gruvbox Dark for nvim/ghostty/tmux/lazygit/yazi, gruvbox-dark syntax theme for delta, FZF colors matched to Gruvbox.
