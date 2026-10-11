# TODO

## Planned

- [ ] **Neovim auto-cd on BufEnter** — The `auto-root` augroup in `lua/kwb/basics.lua`
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

- [ ] **Linux parity** — `linux/packages.sh` and the `fonts` target date from
  March 2026 and predate the Oct 2026 theme, editor, and reference-card work.
  Not needed now; capture for the next Linux desktop. Verify each on a real
  box before committing.
  - [ ] **Fonts** — `make fonts` installs CommitMono Nerd Font on Linux and
    recommends it on macOS. Ghostty now uses Atkinson Hyperlegible Mono with
    Symbols Nerd Font Only for icons. Atkinson is not in the nerd-fonts
    releases; fetch it from the Braille Institute release and Symbols Nerd Font
    from nerd-fonts, then update the macOS echo to the two Brewfile casks.
  - [ ] **TeX packages for `make cards`** — `packages.sh` installs
    `texlive-latex-recommended` and `texlive-fonts-recommended` only.
    `cards.sty` needs extsizes and needspace (Debian: `texlive-latex-extra`)
    and bera (`texlive-fonts-extra`). Unverified on Linux; expect `make cards`
    to fail until added.
  - [ ] **Emacs 31** — `emacs-plus-app` is a macOS cask; apt's Emacs is older
    and the config (`treesit-enabled-modes`, built-in `use-package`, Org 9.8)
    assumes 31. Options: the emacs-snapshot PPA, a build from source, or a
    `linux/emacs.sh`. The Emacs README "first launch" should name the Linux
    path once one exists. `libvterm`/`cmake` already come via Linuxbrew.
  - [ ] **tflint** — Brewfile has it as a macOS-only cask; `brew bundle` skips
    it on Linux, so nvim-lint and `terraform` checks silently lose it. Use the
    tap formula or the GitHub release install script in `packages.sh`.
  - [ ] **Keyboard** — right-option → right-control is `hidutil` only. Decide
    the Linux equivalent (GNOME: `gsettings` xkb options; otherwise
    `keyd`/`xremap`) or document that it is macOS-only on the cards.
  - [ ] **Clipboard** — tmux-yank and nvim `clipboard=unnamedplus` need
    `wl-copy` (Wayland) or `xclip`/`xsel` (X11); add to `packages.sh` and a
    `make doctor` check. nvim already warns at startup if no provider exists.
  - [ ] **`make doctor` on Linux** — the Emacs vterm check looks under
    `$(brew --prefix)/opt/libvterm`, which is right for Linuxbrew too, but the
    `lldb-dap` and `xcrun` branches, the launch-agent checks, and the TeX
    assumption should each be exercised once on Linux.
  - [ ] **Ghostty** — still "build from source" in `packages.sh`; Ghostty now
    publishes Linux packages (Snap, Flatpak, distro repos). Update the note
    or install it.

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
