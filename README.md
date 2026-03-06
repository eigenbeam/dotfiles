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
```

### Prerequisites

Only needed if not using `make bootstrap`:

* GNU Make
* [GNU Stow](https://www.gnu.org/software/stow/) (2.3+, for `--dotfiles` and `--no-folding`)

## What's Included

| Package    | Stow target          | What it sets up                                              |
|------------|----------------------|--------------------------------------------------------------|
| `bash`     | `~/`                 | `.bashrc`, `.bash_profile`, `.profile` (shared with zsh)     |
| `zsh`      | `~/`                 | `.zshrc`, `.zprofile`, `.zshenv`                             |
| `git`      | `~/`                 | `~/.config/git/config`, `ignore`, `hooks/` (XDG layout)     |
| `nvim`     | `~/`                 | Minimal zero-dependency `init.lua` (works in VSCode too)     |
| `ghostty`  | `~/`                 | Terminal config: CommitMono Nerd Font, Zenbones Light theme   |
| `keyboard` | `~/`                 | macOS-only: keyboard remapping via `hidutil` (right-option → control) |
| `tmux`     | `~/`                 | Prefix `C-a`, vi keys, TPM plugins, session persistence      |
| `starship` | `~/`                 | `~/.config/starship.toml` prompt config                      |
| `lazygit`  | `~/`                 | `~/.config/lazygit/config.yml` (Zenbones Light theme)        |
| `yazi`     | `~/`                 | `~/.config/yazi/theme.toml` (Zenbones Light theme)           |
| `ssh`      | `~/`                 | `~/.ssh/config` (connection multiplexing, keepalive)         |

Not stowed (reference/install scripts):

| Directory  | Purpose                                                       |
|------------|---------------------------------------------------------------|
| `homebrew` | `Brewfile` (core) and `Brewfile.extras` (niche/optional)      |
| `linux`    | `packages.sh` — apt-based installs for Linux (Docker, Bitwarden, TeX Live, Quarto, Temurin JDK, Zotero, AWS SSM plugin) |

## Make Targets

| Target             | Description                                            |
|--------------------|--------------------------------------------------------|
| `make` / `make all`| Symlink all stow packages                              |
| `make bootstrap`   | Full setup from scratch (Homebrew + Stow + all + pkgs) |
| `make uninstall`   | Remove all stow symlinks                               |
| `make homebrew`    | Install core packages from `Brewfile`                  |
| `make homebrew-extras` | Install optional packages from `Brewfile.extras`   |
| `make tools`       | Install npm globals (LSPs, prettier) and uv tools      |
| `make ssh`         | Deploy SSH config (manual — not in `make all`)         |
| `make lint`        | Run shellcheck on all shell config files               |
| `make fonts`       | Install CommitMono Nerd Font (Linux: downloads from GitHub, macOS: use cask) |
| `make linux-packages` | Install desktop apps via apt (requires sudo)        |
| `make mac`         | Set macOS-specific defaults (VSCode key repeat)        |
| `make sync`        | Pull latest, install Homebrew packages, re-stow        |
| `make brewfile`    | Dump current Homebrew state to `Brewfile`              |

## Shell Setup

Both bash and zsh share a common `~/.profile` for login environment
(PATH, Homebrew, Rust, NVM). On Linux, `.bashrc` sources `.profile`
automatically for non-login interactive shells (how most Linux
terminals open). Interactive features (aliases, completions, FZF,
prompt) are in the respective rc files.

Key features:
* **Starship** prompt (both shells)
* **NVM** lazy-loaded (~300ms startup savings)
* **FZF** with ripgrep backend
* **zsh-syntax-highlighting** and **zsh-autosuggestions**
* **bat** as MANPAGER and aliased to `cat`
* **Compinit caching** with 24h dump refresh (zsh)

## Platform Handling

* **Homebrew** is detected at `/opt/homebrew` (macOS), `/home/linuxbrew/.linuxbrew` (Linux), or `/usr/local` (Intel Mac)
* **`keyboard`** package is only stowed on macOS (auto-skipped on Linux)
* **`~/.gitconfig-local`** is auto-created on first `make all` with the appropriate credential helper (`osxkeychain` on macOS, `cache` on Linux)
* **Zsh plugins** are found via `$HOMEBREW_PREFIX/share` or `/usr/share` (for apt-installed plugins)
* **Homebrew casks** (Ghostty, Bitwarden, etc.) are macOS-only; Linux equivalents are in `linux/packages.sh`

## Multi-Machine Sync

The `brew` command is wrapped in zsh to auto-update the Brewfile after
any `brew install` or `brew uninstall`. On another machine, pull and
reconcile everything with:

```
$ make sync         # git pull + brew bundle install + re-stow
```

## Reproducibility

To pin exact Homebrew package versions:

```
$ brew bundle lock --file=homebrew/Brewfile
```

This generates `Brewfile.lock.json` for deterministic installs.
