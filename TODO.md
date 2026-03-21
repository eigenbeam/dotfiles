# TODO

## Bugs & Inaccuracies

- [ ] **README is out of date** — Multiple factual errors have accumulated. Ghostty
  description says "JetBrains Mono, Base2Tone EveningDark" but actual config uses
  CommitMono Nerd Font and the parchment theme. Neovim described as "Minimal
  zero-dependency init.lua" but it's a 1030-line config with 30+ plugins. Keyboard
  described as "right-option → control" but the HID codes map right-command →
  left-control. lazygit and yazi are stowed by the Makefile but missing from the
  table. `make cards`, `make brewfile-extras`, `make check`, and `make tools` are
  undocumented. Shell features like zoxide, direnv, and eza aren't mentioned. The
  prerequisites section mentions `--no-folding` but the Makefile never uses it.
  Fix: rewrite the "What's Included" table, make targets table, and shell features
  section to match reality.

- [ ] **Bash completion sourced inside zsh** — `zsh/dot-zshrc:74` sources
  `/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm`, which is a bash completion
  script. Inside zsh, bash-style `complete -F` calls may silently fail or produce
  warnings. Fix: remove this line; NVM's completions are handled by NVM itself when
  loaded, and the lazy-loading stubs cover the interactive case.

- [ ] **Neovim header comment is stale** — `init.lua:7` says "Theme: Kanagawa Paper"
  but the theme is now Parchment (custom base16). Fix: update the comment.

- [ ] **Neovim trailing whitespace removal breaks Markdown** — `init.lua:882-889`
  strips trailing whitespace on every `BufWritePre` for all filetypes. In Markdown
  and Quarto, trailing double-space is a `<br>` line break. Fix: exclude `markdown`
  and `quarto` filetypes from the autocmd, or use a formatter (prettier) to handle
  whitespace instead.

- [ ] **Neovim redundant clipboard setup** — `init.lua:675` sets
  `vim.opt.clipboard = "unnamedplus"` (all yanks/pastes use system clipboard), then
  lines 818-821 explicitly remap `y`/`Y`/`p`/`P` to use the `"+` register, which
  does the same thing. The explicit remaps override the option and prevent any use
  of the unnamed register. Fix: pick one approach — either keep `unnamedplus` and
  remove the explicit remaps, or remove `unnamedplus` and keep the remaps. The same
  duplication exists in the VSCode block (lines 606-610).

- [ ] **Makefile lint target only checks bash** — The `lint` target runs shellcheck
  on `dot-bashrc`, `dot-bash_profile`, and `dot-profile` only. The zsh files
  (`dot-zshrc`, `dot-zprofile`, `dot-zshenv`) are not checked despite the README
  claiming "all shell config files." Fix: add the zsh files that are
  shellcheck-compatible (`dot-zprofile`, `dot-zshenv` are simple enough), or update
  the README to say "bash config files."

- [ ] **Starship `$go` module variable** — `starship.toml:15` uses `$go` in the
  format string but the Starship module is named `golang`. Newer Starship versions
  accept `$go` as an alias, but this should be verified. If it doesn't render, change
  to `$golang`.

## High Priority

- [ ] **Makefile bootstrap doesn't install tools** — `make bootstrap` runs
  `make all` and `make homebrew` but not `make tools`. A fresh machine ends up
  with a partially broken Neovim — LSP servers like `ts_ls` and `dockerls` depend
  on npm packages (typescript-language-server, dockerfile-language-server-nodejs,
  prettier) installed by `make tools`, and uv tools (ipython, marimo) are also
  missing. Fix: add `make tools` to the `bootstrap` target, or at minimum print a
  reminder to run it.

- [ ] **No PATH deduplication** — `bash/dot-profile:15-16,43` prepends/appends to
  PATH without checking for duplicates. Every tmux pane re-sources the profile,
  accumulating duplicate entries. Over a long session, PATH grows unboundedly.
  Fix: for zsh, add `typeset -U path` (built-in dedup). For bash, add a dedup
  function or use a conditional check before each PATH modification.

- [ ] **Missing `HIST_IGNORE_SPACE` in zsh** — Bash has `HISTCONTROL=ignoreboth`
  (which includes `ignorespace` — prefix a command with a space to exclude it from
  history). Zsh only has `HIST_IGNORE_DUPS` (`zsh/dot-zshrc:23-25`), so commands
  containing tokens or passwords passed as arguments get recorded.
  Fix: add `setopt HIST_IGNORE_SPACE` to `dot-zshrc`. Also consider adding
  `HIST_EXPIRE_DUPS_FIRST` (evict duplicates first when history is full).

- [ ] **tmux missing OSC 52 clipboard** — No `set -g set-clipboard on` in the tmux
  config. OSC 52 is the standard escape sequence for clipboard access, and without
  it, copy/paste over SSH or in nested sessions doesn't work reliably. `tmux-yank`
  helps locally but doesn't cover remote use. Fix: add `set -g set-clipboard on`.

- [ ] **tmux missing undercurl support** — The terminal-overrides line
  (`dot-tmux.conf:17`) only enables RGB color. Without undercurl overrides, curly
  underlines (used by Neovim LSP diagnostics to distinguish errors, warnings, hints)
  render as plain underlines. Fix: add undercurl and colored-underline overrides:
  `",*:Smulx=\E[4::%p1%dm"` and
  `",*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m"`.

- [ ] **Neovim plugins install in VSCode mode** — All 30 plugins are cloned and
  installed even when running as a VSCode extension, where only keybindings are used.
  This wastes disk space and startup time. Fix: add `cond = not vim.g.vscode` to
  plugin specs that aren't needed in VSCode (Telescope, LSP, Treesitter, gitsigns,
  DAP, etc.), or wrap the entire `require("lazy").setup(...)` call in an
  `if not vim.g.vscode` guard and provide a minimal plugin list for VSCode mode.

- [x] **Stow `--no-folding` not used** — Fixed: `--no-folding` added to all stow
  invocations in the Linux support commit.

## Medium Priority

- [ ] **Tmux sessionizer** — No fuzzy project switcher for tmux sessions. Currently
  you must manually create and name sessions. A sessionizer keybinding (e.g.,
  `C-a f`) would fuzzy-find project directories and create/attach named sessions.
  Combined with tmux-resurrect, each project gets a persistent workspace.
  Options: write a custom script using fzf, or use a plugin like tmux-sessionx or
  t-smart-tmux-session-manager.

- [ ] **tmux allow-passthrough** — `allow-passthrough` is off by default. This
  blocks terminal image protocols, so Yazi's image preview won't work inside tmux.
  Fix: add `set -g allow-passthrough on` if you want image preview support.

- [ ] **tmux-copycat is unmaintained** — The plugin hasn't been updated in years and
  can conflict with tmux's built-in search improvements in 3.1+. tmux 3.6 has
  capable native search. Fix: evaluate whether you still use copycat's regex search
  features; if not, remove it. If you do, consider tmux-fzf or tmux-fingers as
  alternatives.

- [ ] **Git push.default = upstream** — Requires manually setting up tracking for
  every new branch (`git push -u origin branch-name` the first time). `push.default
  = current` auto-creates the remote branch matching the local name, which is more
  ergonomic for solo/feature-branch workflows. Fix: change to `current` in
  `dot-config/git/config:27` if you prefer the simpler workflow.

- [ ] **Git diff algorithm** — No `diff.algorithm` is set, so git uses the default
  `myers` algorithm. The `histogram` algorithm generally produces more readable diffs
  (better at handling moved blocks of code). Fix: add `[diff] algorithm = histogram`.

- [ ] **Global gitignore gaps** — `dot-config/git/ignore` is missing common entries
  that tend to get accidentally committed: `.idea/`, `.vscode/` (IDE configs),
  `__pycache__/`, `*.pyc` (Python bytecode), `*.log` (log files). These are better
  handled globally than in every project's `.gitignore`. Fix: add the missing
  patterns.

- [ ] **Missing LSP servers for installed languages** — `gopls` is not configured
  despite Go being in Treesitter parsers, filetype autocmds, and the Starship
  prompt. `rust_analyzer` is not configured despite `rustup` being in the Brewfile
  and Rust appearing in Starship. Fix: if you actively write Go or Rust, add the
  LSP servers to `init.lua` and ensure the binaries are installed. If you don't,
  consider removing the Starship modules and Brewfile entries to reduce noise.

- [ ] **Starship missing language modules** — `$java`, `$terraform`, and
  `$docker_context` are not in the format string despite having LSP support and
  tooling configured for all three. Fix: add the modules to `starship.toml` if you
  want version info in your prompt for those languages, or leave them out if you
  prefer a minimal prompt.

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

- [ ] **Duplicated shell config between bash and zsh** — Aliases (lines 7-14),
  FZF variables (lines 39-42 / 62-65), BAT_THEME, and NVM lazy-loading are
  copy-pasted across `dot-bashrc` and `dot-zshrc`. If one changes, the other must
  be manually updated. Fix: extract shared aliases, exports, and functions into a
  common file (e.g., `dot-shell-common`) sourced by both rc files. Alternatively,
  accept the duplication and be disciplined about keeping them in sync.

## Low Priority

- [x] **Hardcoded `/opt/homebrew` paths** — Fixed: replaced with `$HOMEBREW_PREFIX`
  in the Linux support commit.

- [ ] **Unnecessary zsh autoloads** — `zsh/dot-zshrc:35` loads `colors` (provides
  `$fg`/`$bg` variables) but nothing in the config uses them — Starship handles the
  prompt and modern tools handle their own colors. Line 56 loads `promptinit` but
  Starship immediately overrides it. Fix: remove both lines to clean up startup.

- [ ] **ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE set after plugin source** —
  `zsh/dot-zshrc:92` sets `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` after the plugin is
  sourced on lines 90-91. The plugin reads this variable at source time. It happens
  to work because the plugin checks dynamically, but setting it before the `source`
  line is more conventional. Fix: move the assignment above the `source` line.

- [ ] **git-secrets installed but not integrated** — `git-secrets` is in the
  Brewfile but never referenced in any config. The git config's `hooksPath` is
  commented out and the sample pre-commit hook doesn't call it. Fix: either
  integrate it (uncomment hooksPath, add git-secrets to the hook) or remove it from
  the Brewfile.

- [ ] **Brewfile terraform gap** — `terraform` CLI is only in `Brewfile.extras`, but
  `terraform_fmt` is configured as a conform.nvim formatter. Someone who runs
  `make homebrew` but not `make homebrew-extras` will have a formatter that silently
  fails. Fix: move `terraform` to the main Brewfile, or add a conditional check in
  the conform config.

- [ ] **Neovim `linespace = 7` is GUI-only** — `init.lua:659` sets
  `vim.opt.linespace = 7`, which only takes effect in GUI Neovim (Neovide, etc.).
  In terminal Neovim it is silently ignored. Fix: remove it if you only use terminal
  Neovim, or guard it with `if vim.g.neovide then`.

- [ ] **Neovim auto-cd on BufEnter** — `init.lua:909-927` changes the working
  directory on every `BufEnter` by searching for project root markers. If you open
  files from different projects in the same Neovim instance, the cwd keeps switching,
  which can confuse Telescope's `find_files` and `:terminal`. Fix: this is a known
  trade-off of auto-root detection. Consider switching to a per-buffer root approach,
  or accept the behavior.

- [ ] **Neovim empty `vim.lsp.config()` calls** — `init.lua:198-201` has empty
  config calls for `ts_ls`, `terraformls`, `dockerls`, `taplo`. `vim.lsp.enable()`
  alone is sufficient when no custom settings are needed. Fix: remove the empty
  config calls to reduce noise.

- [ ] **Outdated planning docs** — `docs/plans/` contains three documents from the
  kickstart merge. The design and plan docs reference Base2Tone EveningDark, Mason
  for LSP management, and 16 plugins — all of which have changed (Parchment theme,
  native LSP, 30+ plugins). The tooling recommendations doc is partially current.
  Fix: delete or archive the two merge docs. Update or leave the tooling
  recommendations as a backlog.

- [ ] **Reference cards smart-splits attribution** — The tmux reference card
  attributes seamless nvim/tmux navigation to the pain-control plugin. The actual
  mechanism is custom `bind-key -n` mappings checking `@pane-is-vim` (set by
  `smart-splits.nvim`). pain-control provides `|` and `-` splits. Fix: clarify
  the attribution in the reference cards.

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
