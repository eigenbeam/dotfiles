# Future Improvements

## High impact, low effort

- [ ] **direnv** — Per-project environment auto-loading. `cd` into a project and `.envrc` sets up env vars, PATH, virtualenvs automatically. Pairs well with `uv` (`layout python`). https://github.com/direnv/direnv

- [ ] **zoxide** — Smarter `cd` that learns directory habits. `z dot` jumps to `~/projects/dotfiles` from anywhere. https://github.com/ajeetdsouza/zoxide

- [ ] **Tmux sessionizer** — Keybinding (e.g., `C-a f`) that fuzzy-finds projects and creates/attaches named tmux sessions. Combined with tmux-resurrect, every project gets a persistent workspace. https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

- [ ] **Shell utility functions** — Beyond aliases: `mkcd` (mkdir + cd), `extract` (universal archive extractor), `gco` (fuzzy git branch switcher via fzf), `fkill` (fuzzy process killer).

## High impact, medium effort

- [ ] **CI for dotfiles** — GitHub Actions workflow: shellcheck, dry-run stow in a container, Brewfile syntax validation. Catches breakage before pulling on another machine.

- [ ] **Neovim dual config (lazy.nvim)** — Keep the zero-dependency init.lua for SSH/sysadmin portability. Add a second profile with telescope, treesitter, nvim-cmp for the main machine. Neovim supports `NVIM_APPNAME` so both coexist: `nvim` (minimal) vs `NVIM_APPNAME=nvim-full nvim` (full IDE).

- [ ] **Atuin** — Replaces HISTFILE with a SQLite database. Full-text search, cross-machine sync, TUI for history browsing. Far more powerful than `Ctrl-R`. https://github.com/atuinsh/atuin

## "Final form" tier

- [ ] **Nix + Home Manager** — Declarative, reproducible, rollbackable system config. Declare exact tool versions and plugin sets; Nix builds it all deterministically. Same environment on every machine. Steep learning curve. https://nix-community.github.io/home-manager/

- [ ] **Chezmoi migration** — Like stow but with templating and encryption. Git config becomes `email = {{ .email }}` with per-machine values. Encrypted secrets support. `chezmoi diff` previews changes. Solves "personal email in public repo" and "different config per machine" problems stow can't handle. https://www.chezmoi.io/
