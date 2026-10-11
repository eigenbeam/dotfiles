Dotfiles
========

Shell, editor, git, and terminal config managed with [GNU
Stow](https://www.gnu.org/software/stow/). Works on macOS (Homebrew +
Apple Silicon) and Linux (Linuxbrew + apt), with bash/zsh portability.

## Quick Start

```
$ make bootstrap    # Fresh machine: installs Homebrew, Stow, configs, and packages
```

On Linux, bootstrap also installs fonts and reminds you to run:

```
$ sudo make linux-packages   # Desktop apps: Docker, Bitwarden, TeX Live, etc.
```

Or step by step:

```
$ make              # Symlink all configs via stow
$ make homebrew     # Install core Homebrew packages
$ make doctor       # Verify symlinks, tools, and shell setup
```

### Prerequisites

Only needed if not using `make bootstrap`:

* GNU Make
* [GNU Stow](https://www.gnu.org/software/stow/) 2.4+ (`--dotfiles` on directories)

## What's Included

All packages stow to `$HOME`.

| Package    | What it sets up                                                       |
|------------|-----------------------------------------------------------------------|
| `ai`       | `~/.claude/CLAUDE.md` — global Claude Code instructions               |
| `bash`     | `.bashrc`, `.bash_profile`, `.profile` (shared with zsh), `.shell-common`, `~/.local/bin/tmux-sessionizer` |
| `zsh`      | `.zshrc`, `.zprofile`, `.zshenv`                                      |
| `git`      | `~/.config/git/config`, `ignore` (XDG layout)                         |
| `nvim`     | Neovim 0.12, `vim.pack`, `lua/kwb/` modules, LSP/DAP, Claude Code (see its README) |
| `emacs`    | Emacs 31: eglot, apheleia, dape, corfu/vertico, Claude Code (see its README) |
| `ghostty`  | Terminal config: CommitMono Nerd Font, Gruvbox Dark theme             |
| `keyboard` | macOS-only: right-option → right-control via `hidutil` launch agent   |
| `tmux`     | Prefix `C-a`, vi keys, TPM plugins, session persistence               |
| `starship` | `~/.config/starship.toml` prompt config                               |
| `lazygit`  | `~/.config/lazygit/config.yml` (Gruvbox Dark theme)                   |
| `yazi`     | `~/.config/yazi/` (Gruvbox Dark theme, behavior config)               |
| `ssh`      | `~/.ssh/config` (connection multiplexing, keepalive)                  |

Not stowed:

| Directory         | Purpose                                                            |
|-------------------|--------------------------------------------------------------------|
| `homebrew`        | `Brewfile` (core packages)                                         |
| `linux`           | `packages.sh` — apt-based installs for Linux (Docker, Bitwarden, TeX Live, Quarto, Temurin JDK, Zotero, AWS SSM plugin) |
| `reference-cards` | LaTeX sources for keybinding/language reference cards              |

## Make Targets

| Target                | Description                                                   |
|-----------------------|---------------------------------------------------------------|
| `make` / `make all`   | Symlink all stow packages (runs `make keyboard` on macOS)     |
| `make bootstrap`      | Full setup from scratch (Homebrew + Stow + all + homebrew + tools) |
| `make uninstall`      | Remove all stow symlinks                                      |
| `make doctor`         | Verify symlinks, tools, configs, shell, and the editor toolchains |
| `make homebrew`       | Install core packages from `Brewfile`                         |
| `make brewfile`       | Dump current Homebrew state to `Brewfile`                     |
| `make tools`          | Install npm globals (LSPs, prettier) and uv tools             |
| `make debug-adapters` | Download the Java and JS debug adapters (Emacs dape, nvim-dap) |
| `make ssh`            | Deploy SSH config (manual — not in `make all`)                |
| `make keyboard`       | Stow and load the key-remap launch agent (macOS only)         |
| `make lint`           | Shellcheck bash; paren-check elisp; stylua + syntax-check the nvim Lua |
| `make fonts`          | Install CommitMono Nerd Font (Linux: downloads from GitHub, macOS: use cask) |
| `make linux-packages` | Install desktop apps via apt (requires sudo)                  |
| `make ssm-plugin`     | Install AWS Session Manager Plugin from AWS (requires sudo)   |
| `make sync`           | Pull latest, install Homebrew packages, re-stow               |
| `make tex`            | Install TeX packages for `make cards` (macOS, sudo)           |
| `make cards`          | Build `reference-cards/reference-cards.pdf` via pdflatex      |
| `make language-cards` | Build the per-language cards in `reference-cards/`            |

## Shell Setup

Both bash and zsh share a common `~/.profile` for login environment
(PATH, Homebrew, Rust, NVM). On Linux, `.bashrc` sources `.profile`
automatically for non-login interactive shells (how most Linux
terminals open). Shared interactive config (aliases, FZF, NVM
lazy-load) lives in `~/.shell-common`; shell-specific features
(completions, plugins, prompt) are in the respective rc files.

Key features:
* **Starship** prompt (both shells)
* **NVM** lazy-loaded on first use of `nvm`/`node`/`npm`/`npx`
* **FZF** with ripgrep backend
* **zsh-syntax-highlighting** and **zsh-autosuggestions**
* **bat** as MANPAGER; `ll`/`lt` via eza (`ls` and `cat` stay stock)
* **Compinit caching** with 24h dump refresh (zsh)

## Platform Handling

* **Homebrew** is detected at `/opt/homebrew` (macOS), `/home/linuxbrew/.linuxbrew` (Linux), or `/usr/local` (Intel Mac)
* **`keyboard`** package is only stowed on macOS (auto-skipped on Linux)
* **`~/.gitconfig-local`** is auto-created on first `make all` with the appropriate credential helper (`osxkeychain` on macOS, `cache` on Linux)
* **Zsh plugins** are found via `$HOMEBREW_PREFIX/share` or `/usr/share` (for apt-installed plugins)
* **Homebrew casks** (Ghostty, Bitwarden, etc.) are macOS-only; Linux equivalents are in `linux/packages.sh`

## Multi-Machine Sync

After installing or removing packages, run `make brewfile` to dump the
installed state to `homebrew/Brewfile` and commit it. On another
machine:

```
$ make sync         # git pull + brew bundle install + re-stow
```
