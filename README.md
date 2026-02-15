Dotfiles
========

Shell, editor, git, and terminal config managed with [GNU
Stow](https://www.gnu.org/software/stow/). macOS-focused (Homebrew +
Apple Silicon), with bash/zsh portability.

## Quick Start

```
$ make bootstrap    # Fresh machine: installs Homebrew, Stow, configs, and packages
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
| `nvim`     | `~/.config/`         | Minimal zero-dependency `init.lua` (works in VSCode too)     |
| `ghostty`  | `~/`                 | Terminal config: JetBrains Mono, Base2Tone EveningDark colors |
| `tmux`     | `~/`                 | Prefix `C-a`, vi keys, TPM plugins, session persistence      |
| `starship` | `~/`                 | `~/.config/starship.toml` prompt config                      |

Not stowed (reference/install scripts):

| Directory  | Purpose                                                       |
|------------|---------------------------------------------------------------|
| `homebrew` | `Brewfile` (core) and `Brewfile.extras` (niche/optional)      |
| `iterm2`   | iTerm2 profile and color scheme (`make iterm` to install)     |
| `aws`      | AWS Session Manager plugin install script                     |

## Make Targets

| Target             | Description                                            |
|--------------------|--------------------------------------------------------|
| `make` / `make all`| Symlink all stow packages                              |
| `make bootstrap`   | Full setup from scratch (Homebrew + Stow + all + pkgs) |
| `make uninstall`   | Remove all stow symlinks                               |
| `make homebrew`    | Install core packages from `Brewfile`                  |
| `make homebrew-extras` | Install optional packages from `Brewfile.extras`   |
| `make lint`        | Run shellcheck on all shell config files               |
| `make iterm`       | Install iTerm2 profile to DynamicProfiles              |
| `make mac`         | Set macOS-specific defaults (VSCode key repeat)        |
| `make brewfile`    | Dump current Homebrew state to `Brewfile`              |

## Shell Setup

Both bash and zsh share a common `~/.profile` for login environment
(PATH, Homebrew, Rust, Java, NVM). Interactive features (aliases,
completions, FZF, prompt) are in the respective rc files.

Key features:
* **Starship** prompt (both shells)
* **NVM** lazy-loaded (~300ms startup savings)
* **FZF** with ripgrep backend
* **zsh-syntax-highlighting** and **zsh-autosuggestions**
* **bat** as MANPAGER and aliased to `cat`
* **Compinit caching** with 24h dump refresh (zsh)

## Reproducibility

To pin exact Homebrew package versions:

```
$ brew bundle lock --file=homebrew/Brewfile
```

This generates `Brewfile.lock.json` for deterministic installs.
