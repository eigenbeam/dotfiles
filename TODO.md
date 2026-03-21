# TODO

## Bugs & Inaccuracies

- [x] **README is out of date** — Fixed: corrected nvim description ("30+ plugins"
  not "zero-dependency"), fixed lint description, added `make cards` target. Most
  other inaccuracies were already corrected in the Linux support commit.

- [x] **Bash completion sourced inside zsh** — Fixed: NVM lazy-loading moved to
  shared `.shell-common` file, no longer directly sourcing bash completions in zsh.

- [x] **Neovim header comment is stale** — Fixed: now correctly says "Zenbones Light".

- [x] **Neovim trailing whitespace removal breaks Markdown** — Fixed: excluded
  `markdown` and `quarto` filetypes from the BufWritePre whitespace strip.

- [x] **Neovim redundant clipboard setup** — Fixed: removed explicit `"+` register
  remaps from both VSCode and regular blocks; `unnamedplus` handles clipboard.

- [x] **Makefile lint target only checks bash** — Fixed: now lints `.shell-common`
  too. Zsh files intentionally excluded (not shellcheck-compatible).

- [x] **Starship `$go` module variable** — Fixed: changed to `$golang` to match
  the module name.

## High Priority

- [x] **Makefile bootstrap doesn't install tools** — Fixed: added `make tools` to
  the `bootstrap` target.

- [x] **No PATH deduplication** — Fixed: added `typeset -U path` to `dot-zshrc`.

- [x] **Missing `HIST_IGNORE_SPACE` in zsh** — Fixed: `setopt HIST_IGNORE_SPACE`
  added to `dot-zshrc`.

- [x] **tmux missing OSC 52 clipboard** — Fixed: added `set -g set-clipboard on`.

- [x] **tmux missing undercurl support** — Fixed: added Smulx and Setulc
  terminal-overrides for undercurl and colored-underline support.

- [x] **Neovim plugins install in VSCode mode** — Fixed: wrapped lazy.nvim
  bootstrap and `require("lazy").setup(...)` in `if not vim.g.vscode` guard.

- [x] **Stow `--no-folding` not used** — Fixed: `--no-folding` added to all stow
  invocations in the Linux support commit.

## Medium Priority

- [ ] **Tmux sessionizer** — No fuzzy project switcher for tmux sessions. Currently
  you must manually create and name sessions. A sessionizer keybinding (e.g.,
  `C-a f`) would fuzzy-find project directories and create/attach named sessions.
  Combined with tmux-resurrect, each project gets a persistent workspace.
  Options: write a custom script using fzf, or use a plugin like tmux-sessionx or
  t-smart-tmux-session-manager.

- [x] **tmux allow-passthrough** — Fixed: added `set -g allow-passthrough on`.

- [x] **tmux-copycat is unmaintained** — Fixed: removed plugin. Using native tmux
  search instead.

- [x] **Git push.default = upstream** — Fixed: changed to `simple` (Git's default).
  Same safety as `upstream` but prevents accidental cross-name pushes.

- [x] **Git diff algorithm** — Fixed: set `algorithm = histogram` in git config.

- [x] **Global gitignore gaps** — Fixed: added `.idea/`, `.vscode/`, `__pycache__/`,
  `*.pyc`, `*.log` to global gitignore.

- [x] **Missing LSP servers for installed languages** — Fixed: removed Go and Rust
  modules from Starship (not actively used). No LSP servers added.

- [x] **Starship missing language modules** — Fixed: added `$java`, `$terraform`,
  and `$docker_context` to format string with matching sections.

- [ ] **Yazi has no behavioral config** — Only a `theme.toml` exists. There is no
  `yazi.toml` (show hidden files, sorting, preview settings, image preview) or
  `keymap.toml` (custom keybindings). All behavior is default. Fix: add a
  `yazi.toml` if you want to customize behavior — common settings include
  `show_hidden = true`, image preview backend config, and custom opener rules.

- [ ] **Shell utility functions** — The shell configs have aliases but no utility
  functions. Common useful ones: `mkcd` (mkdir + cd), `extract` (universal archive
  extractor), `gco` (fuzzy git branch switcher via fzf), `fkill` (fuzzy process
  killer). Fix: add a shared functions file sourced by both bash and zsh, or add
  them directly to each rc file.

- [x] **Duplicated shell config between bash and zsh** — Fixed: shared config
  extracted to `dot-shell-common`, sourced by both `.bashrc` and `.zshrc`.

## Low Priority

- [x] **Hardcoded `/opt/homebrew` paths** — Fixed: replaced with `$HOMEBREW_PREFIX`
  in the Linux support commit.

- [x] **Unnecessary zsh autoloads** — Fixed: removed `colors` and `promptinit`
  autoloads from `dot-zshrc`.

- [x] **ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE set after plugin source** — Fixed: moved
  assignment before the plugin source loop.

- [x] **git-secrets installed but not integrated** — Kept as opt-in per-repo
  (`git secrets --install` in repos that need it). No global hooks to avoid
  breaking repo-local pre-commit setups.

- [x] **Brewfile terraform gap** — Fixed: added `hashicorp/tap/terraform` to the
  main Brewfile.

- [x] **Neovim `linespace = 7` is GUI-only** — Fixed: removed (terminal-only setup).

- [ ] **Neovim auto-cd on BufEnter** — `init.lua:909-927` changes the working
  directory on every `BufEnter` by searching for project root markers. If you open
  files from different projects in the same Neovim instance, the cwd keeps switching,
  which can confuse Telescope's `find_files` and `:terminal`. Fix: this is a known
  trade-off of auto-root detection. Consider switching to a per-buffer root approach,
  or accept the behavior.

- [x] **Neovim empty `vim.lsp.config()` calls** — Fixed: removed empty config calls;
  `vim.lsp.enable()` handles them.

- [x] **Outdated planning docs** — Fixed: deleted the two obsolete kickstart merge
  docs. Kept tooling recommendations as backlog reference.

- [x] **Reference cards smart-splits attribution** — Fixed: navigation and resize
  bindings now attributed to smart-splits. Also removed copycat keybindings.

- [ ] **Track machine-local configs in git (encrypted)** — `~/.ssh/config-local`
  and `~/.gitconfig-local` contain machine-specific settings (hosts, credentials,
  keys) and aren't version-controlled. If the machine dies, they're lost.
  **Preferred approach: `age` + SSH keys.** Each machine's `id_ed25519` can decrypt;
  no GPG or separate keyfile needed. A `local/` directory (gitignored) holds
  plaintext configs, while `local/secrets.age` is the encrypted blob checked into
  git. `local/authorized-keys` lists public keys of all machines (safe to commit).
  Two Makefile targets: `make local-encrypt` (tar + age encrypt) and
  `make local-decrypt` (age decrypt + untar). Pre-commit hook can warn if plaintext
  is newer than the encrypted blob. **Alternatives considered:** git-crypt
  (transparent but needs GPG or symmetric keyfile), Bitwarden CLI (good as a backup
  mechanism, not a daily workflow), Yubikey (future hardening — resident SSH keys
  work with age via ssh-agent, so this upgrades naturally). A practical combo:
  age for daily use, Bitwarden as backup, Yubikey as optional future step.

- [ ] **Server and minimal make targets** — Two tiers for non-desktop machines:
  **Tier 1 (`make server`):** For controlled servers (Docker, cloud VMs) where you
  have root. Stows a subset of packages (bash, zsh, git, nvim, tmux, starship —
  skip ghostty, keyboard) and installs tools via apt/dnf through a new
  `linux/server-packages.sh` script (stow, zsh, neovim, tmux, starship, fzf,
  ripgrep, fd, bat, git-delta). Paired with `make bootstrap-server` that runs the
  install script + `make server` + `make ssh`.
  **Tier 2 (`make minimal`):** For uncontrolled servers (shared EC2, HPC) where you
  likely don't have root. No stow dependency — uses direct `ln -sf` to link bash
  and git configs only. Works with just bash + vi/vim. Requires a new portable
  `vim/dot-vimrc` with sane defaults (line numbers, search, indent, no plugins) to
  mirror basic neovim muscle memory. `.bashrc` needs a fallback `PS1` for when
  starship isn't installed. No downloading of external binaries.
  **New files needed:** `linux/server-packages.sh`, `vim/dot-vimrc`.
  **Changes to existing files:** Makefile (new targets), `bash/dot-bashrc` (fallback PS1).

## Aspirational

- [ ] **CI for dotfiles** — No automated validation exists. A GitHub Actions
  workflow could run shellcheck, dry-run stow in a container, validate Brewfile
  syntax, and check for broken symlinks. Catches breakage before pulling on another
  machine.

- [ ] **Atuin** — Replaces HISTFILE with a SQLite database. Provides full-text
  search, cross-machine sync, and a TUI for history browsing. Far more powerful
  than `Ctrl-R`. Would also solve the missing `HIST_IGNORE_SPACE` issue since Atuin
  has its own filtering. https://github.com/atuinsh/atuin

- [ ] **Caps Lock → Escape remap** — Very common for Vim users and not present in
  the keyboard config. May already be handled in System Settings or Karabiner. If
  not, it can be added to the existing `hidutil` plist or configured in Ghostty.

- [ ] **Vi mode in zsh/bash** — Use vim keybindings in the shell for consistency
  with neovim. Zsh's vi-mode is better than bash's (faster mode switching, better
  widgets). **Tradeoffs:** loses default emacs-mode bindings (`C-a`, `C-e`, `C-r`,
  `C-w`) that are optimized for single-line editing; mode ambiguity without cursor
  shape configuration; FZF and zsh-autosuggestions key bindings assume emacs mode
  and need manual rebinding. **If adopted:** configure cursor shape change per mode
  (block for normal, beam for insert), rebind FZF/autosuggestion keys for vi-mode,
  set up `Esc v` or a binding to edit command in neovim. Consider keeping emacs
  mode and just adding a keybind to open `$EDITOR` for complex commands as a
  lighter alternative.

- [ ] **`~/.inputrc` for readline** — No readline configuration exists. This affects
  bash, the Python REPL, and any readline-based tool. Common settings: vi mode,
  case-insensitive completion, visible stats, colored completion prefix. Fix: add
  an `inputrc` stow package if desired.

- [ ] **Nix + Home Manager** — Declarative, reproducible, rollbackable system
  config. Declare exact tool versions and plugin sets; Nix builds it all
  deterministically. Same environment on every machine. Steep learning curve.
  https://nix-community.github.io/home-manager/

- [ ] **Chezmoi migration** — Like stow but with templating and encryption. Git
  config becomes `email = {{ .email }}` with per-machine values. Encrypted secrets
  support. `chezmoi diff` previews changes. Solves "personal email in public repo"
  and "different config per machine" problems stow can't handle.
  https://www.chezmoi.io/

## Done

- [x] **direnv** — Per-project environment auto-loading via `.envrc`.
- [x] **zoxide** — Smarter `cd` that learns directory habits.
- [x] **Neovim with lazy.nvim** — Kickstart-inspired config with Telescope, LSP,
  Treesitter, blink.cmp, gitsigns, DAP, conform, nvim-lint, and 30+ plugins.
  Custom Parchment theme via base16-nvim.
