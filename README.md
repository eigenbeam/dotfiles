Dotfiles
========

This project contains important shell dotfiles, environment variables,
aliases, git, emacs, neovim, and tmux config, that I want to keep
across machines. It uses [GNU
Stow](https://www.gnu.org/software/stow/) to manage these files.

## Prerequisites

* GNU Make
* GNU Stow

## Installing

```
$ make            # Symlink all configs
$ make homebrew   # Install core Homebrew packages
$ make bootstrap  # Full setup from scratch (installs Homebrew + Stow + configs)
```

## Reproducibility

To pin exact Homebrew package versions:

```
$ brew bundle lock --file=homebrew/Brewfile
```

This generates `Brewfile.lock.json` for deterministic installs.

## CLI Tools

* [bat](https://github.com/sharkdp/bat)
* [bat-extras](https://github.com/eth-p/bat-extras)
* [bottom](https://github.com/clementtsang/bottom)
* [delta](https://github.com/dandavison/delta)
* [entr](https://github.com/eradman/entr)
* [eza](https://github.com/eza-community/eza)
* [fd-find](https://github.com/sharkdp/fd)
* [fzf](https://github.com/junegunn/fzf)
* [neovim](https://github.com/neovim/neovim)
* [ripgrep](https://github.com/BurntSushi/ripgrep)
* [Rust](https://www.rust-lang.org/tools/install)
* [shfmt](https://github.com/mvdan/sh)
* [tmux](https://github.com/tmux/tmux)
* [uv](https://github.com/astral-sh/uv)
