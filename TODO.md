# TODO

## Planned

- [ ] **Neovim auto-cd on BufEnter** — The `auto-root` augroup in `init.lua`
  changes cwd whenever a buffer from a different project is entered, which
  confuses Telescope and `:terminal` when editing across projects. Either switch
  to a per-buffer root approach or accept the trade-off.

- [ ] **Track machine-local configs in git (encrypted)** — `~/.ssh/config-local`
  and `~/.gitconfig-local` are lost if the machine dies. Approach: `age` + SSH
  keys (each machine's `id_ed25519` decrypts; `age` is already in the Brewfile).
  Gitignored `local/` holds plaintext; `local/secrets.age` is committed;
  `local/authorized-keys` lists each machine's public key. Targets:
  `make local-encrypt` / `make local-decrypt`. Bitwarden as backup.

- [ ] **Server and minimal make targets** — Two tiers for non-desktop machines.
  `make server` (root available): stow bash, zsh, git, nvim, tmux, starship and
  install tools via a new `linux/server-packages.sh`; paired `make bootstrap-server`.
  `make minimal` (no root, no stow): `ln -sf` bash and git configs only, plus a
  new plugin-free `vim/dot-vimrc` and a fallback `PS1` in `.bashrc` for when
  starship is absent.

## Ideas

- [ ] **CI** — GitHub Actions: shellcheck, dry-run stow in a container, Brewfile
  syntax check.

- [ ] **Atuin** — SQLite shell history with full-text search, cross-machine sync,
  and a TUI. https://github.com/atuinsh/atuin

- [ ] **Caps Lock → Escape** — Not in the `hidutil` plist (only right-option is
  remapped). Add to the plist or configure in Ghostty.

- [ ] **Vi mode in zsh** — Costs the emacs-mode bindings (`C-a`, `C-e`, `C-r`,
  `C-w`) and requires rebinding FZF/autosuggestion keys and configuring cursor
  shape per mode. Lighter alternative: keep emacs mode, add a keybind to edit
  the current command in `$EDITOR`.

- [ ] **`~/.inputrc`** — No readline config exists (affects bash, Python REPL).
  Candidates: case-insensitive completion, colored completion prefix.

- [ ] **Nix + Home Manager** — Declarative, reproducible, rollbackable; steep
  learning curve. https://nix-community.github.io/home-manager/

- [ ] **Chezmoi** — Stow plus templating and encryption; would solve per-machine
  values and secrets. https://www.chezmoi.io/

- [ ] **AWS CLI toolkit** — Quick wins: `cli_pager =` and
  `cli_auto_prompt = on-partial` in `~/.aws/config`; fzf aliases for profile
  switching and SSM connect. Credentials: `granted` (SSO) or `aws-vault` (IAM +
  MFA). Service tools: `cw` (CloudWatch tail), `s5cmd` (S3), `steampipe` (SQL
  over live resources), `chamber` (Parameter Store).
  https://github.com/common-fate/granted
  https://github.com/lucagrulla/cw
  https://github.com/peak/s5cmd
  https://github.com/turbot/steampipe

- [ ] **sesh** — Replacement for `tmux-sessionizer` with zoxide frecency, a
  unified picker for existing and new sessions, and per-session startup commands.
  `brew install sesh`. https://github.com/joshmedeski/sesh
