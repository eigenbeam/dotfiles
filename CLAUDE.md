# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS and Linux. Config files are managed with [GNU Stow](https://www.gnu.org/software/stow/) using `--dotfiles` mode — files named `dot-*` become `.*` when symlinked. All stow packages target `$HOME`. Package management uses Homebrew on both platforms (Linuxbrew on Linux). The `keyboard` package is macOS-only and automatically skipped on Linux.

## Common Commands

| Command | Purpose |
|---------|---------|
| `make` | Symlink all stow packages to `$HOME` |
| `make bootstrap` | Full setup from scratch (Homebrew + Stow + configs + packages) |
| `make uninstall` | Remove all stow symlinks |
| `make homebrew` | Install core packages from `homebrew/Brewfile` |
| `make lint` | Run shellcheck on bash config files |
| `make sync` | Pull latest, install Homebrew packages, re-stow |
| `make tools` | Install npm globals (LSPs, prettier) and uv tools |
| `make ssh` | Deploy SSH config (excluded from `make all` — must be run manually) |

## Architecture

**Stow package convention:** Each top-level directory (bash, zsh, git, nvim, ghostty, etc.) is a stow package. Files mirror their target path under `$HOME`. For example, `nvim/dot-config/nvim/init.lua` becomes `~/.config/nvim/init.lua`.

**Shell layering:**
- `bash/dot-profile` — shared login environment (PATH, Homebrew, Rust, NVM, Java). Sourced by both `.zprofile` and `.bash_profile`.
- `zsh/dot-zshrc` — interactive zsh config (aliases, completions, FZF, plugins, lazy-loaded NVM).
- `bash/dot-bashrc` — interactive bash config.

**Neovim** (`nvim/dot-config/nvim/init.lua`): Single-file config using lazy.nvim. Has a `vim.g.vscode` branch — when running inside VSCode Neovim extension, it loads a minimal keybinding-only config; otherwise it loads the full setup (Telescope, LSP, Treesitter, conform, nvim-lint, nvim-dap, etc.). Theme: Zenbones Light.

**Brew auto-sync:** The `brew` command is wrapped in `.zshrc` to auto-dump `Brewfile` after any install/uninstall, keeping `homebrew/Brewfile` always current.

**Git config** uses XDG layout (`~/.config/git/`), delta for diffs, and includes `~/.gitconfig-local` for machine-specific overrides. The `make all` target creates this file if missing.

## Conventions

- **Indent:** 4 spaces (2 for YAML). Tabs only in Makefiles. See `.editorconfig`.
- **Line endings:** LF only.
- **Shell linting:** `shellcheck` on bash files (`make lint`). Zsh files are not linted.
- **Neovim formatting:** conform.nvim with stylua (Lua), ruff (Python), prettier (JS/TS/JSON/YAML/MD), terraform_fmt, taplo (TOML). Format-on-save is enabled.
- **Light theme throughout:** Zenbones Light for nvim/ghostty/lazygit/yazi, GitHub syntax theme for delta, FZF colors matched to Zenbones.
