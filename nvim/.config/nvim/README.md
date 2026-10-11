# Neovim

Neovim 0.12 with the built-in `vim.pack`, built-in LSP and tree-sitter, and a
small set of well-adopted plugins on top. Dark Gruvbox like the rest of the
dotfiles. The layout mirrors `emacs/dot-emacs.d/`.

## Layout

| File | Role |
|---|---|
| `init.lua` | Leader, providers, the `PackChanged` build hook, loads the modules below |
| `lua/kwb/basics.lua` | Options, filetypes, keymaps, netrw, quality-of-life autocmds (also loaded in VS Code) |
| `lua/kwb/vscode.lua` | The `vim.g.vscode` branch: maps leader keys to VS Code commands, nothing else |
| `lua/kwb/theme.lua` | gruvbox, nvim-web-devicons, mini.statusline |
| `lua/kwb/packages.lua` | telescope, tree-sitter, gitsigns, lazygit, smart-splits, which-key, zen-mode, mini.ai/surround, claudecode |
| `lua/kwb/dev.lua` | LSP, blink.cmp, conform, nvim-lint, nvim-dap adapters, quarto |
| `lua/kwb/pack.lua` | `vim.pack.add` wrapper: GitHub shorthand, no install prompt |
| `ftplugin/java.lua` | jdtls through nvim-jdtls, with the java-debug bundle |
| `nvim-pack-lock.json` | Plugin revisions; committed |
| `lint.lua` | `make lint` syntax pass (`loadfile` only, runs nothing) |

Runtime state lives under `~/.local/share/nvim` (plugins in
`site/pack/core/opt`, parsers in `site/parser`) and `~/.cache/nvim` (jdtls
workspaces).

## First launch

1. `brew bundle --file homebrew/Brewfile` (`neovim`, `tree-sitter-cli`,
   `stylua`, and the language servers), then `make tools` for the npm ones
   and `make debug-adapters` for the Java and JS debug adapters.
2. On a machine that ran lazy.nvim or packer before, remove their leftovers
   first; `vim.pack` honours `packpath`, so anything under `site/pack` would
   load alongside the new plugins:

       rm -rf ~/.local/share/nvim/{lazy,mason,site/pack/packer,site/queries}

3. Start `nvim`. Plugins install from the lockfile in one parallel step,
   then tree-sitter parsers compile in the background (a few minutes the
   first time; `:checkhealth nvim-treesitter` when in doubt). `:restart`.
4. Julia: LanguageServer.jl is not installed by the config. Once:

       julia --project=~/.julia/environments/nvim-lspconfig \
         -e 'using Pkg; Pkg.add(["LanguageServer", "SymbolServer", "StaticLint"])'

`make doctor` checks all of this.

## Plugins

`vim.pack` is still labelled experimental in 0.12, but it has a lockfile and
hooks, which is what this config needs.

| Task | How |
|---|---|
| Add a plugin | Add it to the `require("kwb.pack")({...})` list in the right module, restart |
| Update | `:lua vim.pack.update()`, read the diff buffer, `:w` to apply (or `:q`), commit the lockfile |
| Revert an update | `git checkout -- nvim-pack-lock.json`, then `:lua vim.pack.update(nil, { target = "lockfile" })` |
| Remove | Delete it from the list, restart, `:lua vim.pack.del({ "name" })` |
| Build steps | The `PackChanged` hook in `init.lua` (`make` for fzf-native, parser rebuild for nvim-treesitter) |

Pinned: blink.cmp to `1.*`, nvim-treesitter to `main`. Everything else
tracks its default branch.

## Keys

Leader is Space. `which-key` shows the rest after a pause.

| Key | Action |
|---|---|
| `<leader>sf` / `sg` / `sw` / `s.` / `sb` | find files / live grep / grep word / recent / buffers |
| `<leader>sd` / `sk` / `s?` / `sr` / `sn` | diagnostics / keymaps / help / resume / this config |
| `<leader>sN` / `sO` | grep / browse `~/notes` |
| `<leader>/` | fuzzy find in buffer |
| `<leader>e` / `E` | netrw here / in a split |
| `<leader>|` / `-` | vertical / horizontal split (`<C-w>=`, `<C-w>q` are native) |
| `C-h/j/k/l`, `M-h/j/k/l` | move / resize across nvim splits and tmux panes |
| `S-h` / `S-l` / `<leader>bd` | previous / next / delete buffer |
| `<leader>gg` / `gs` / `gc` / `gf` | lazygit / git status / commits / file history |
| `]h` / `[h` / `<leader>hs` / `hr` / `hb` / `hd` / `hD` | hunks: next / prev / stage / reset / blame / diff index / diff HEAD |
| `<leader>f` / `ll` | format buffer / lint now |
| `<leader>tt` / `tz` / `th` | terminal / zen mode / inlay hints |
| `<Esc><Esc>` (terminal) | back to normal mode; a single Esc reaches the TUI inside |
| `<leader>w` / `q` / `Q` | write / quit / quit all without saving |

LSP, active in every buffer with a server. Neovim's own defaults do most of
it:

| Key | Action |
|---|---|
| `grr` / `grn` / `gra` / `gri` / `grt` | references / rename / code action / implementation / type definition |
| `K` / `[d` / `]d` / `<C-w>d` | hover / previous / next diagnostic / diagnostic float |
| `gd` / `gD` | definition / declaration |
| `<leader>rn` / `ca` / `d` | rename / code action / diagnostic float (aliases of the above) |
| `<C-space>`, `<C-y>` | blink.cmp: open menu, accept |

Debugging (nvim-dap, `<leader>D` prefix):

| Key | Action |
|---|---|
| `b` / `B` | toggle breakpoint / conditional breakpoint |
| `c` | continue, or start (prompts for a launch config) |
| `o` / `i` / `O` | step over / into / out |
| `r` / `l` / `t` / `u` | REPL / run last / terminate / toggle dap-ui |

Claude Code (`<leader>a` prefix): see below.

## Languages

| Language | Filetype | LSP | Format on save | Lint | Debugger |
|---|---|---|---|---|---|
| C / C++ | `c`, `cpp` | clangd (Xcode CLT) | trim whitespace only | | `lldb-dap` (CLT, via `xcrun`) |
| Python | `python` | pyright | ruff | ruff | `debugpy`: `uv add --dev debugpy` |
| Java | `java` | jdtls + java-debug bundle | trim whitespace only | | `java` (`make debug-adapters`) |
| JS / TS | `javascript`, `typescript`, `*react` | ts_ls (`make tools`) | prettier | | `pwa-node` (`make debug-adapters`) |
| Julia | `julia` | julials (LanguageServer.jl, see above) | | | |
| Shell | `sh`, `bash` | bashls | trim whitespace only | | |
| Lua | `lua` | lua_ls | stylua | | |
| YAML | `yaml` | yamlls (SchemaStore) | prettier | | |
| Terraform | `terraform` | terraformls | terraform fmt | tflint | |
| Dockerfile | `dockerfile` | dockerls (`make tools`) | | | |
| TOML | `toml` | taplo | taplo | | |
| JSON / CSS / HTML / Markdown | | | prettier | | |
| Quarto | `quarto` | otter (code cells) | off | | |

Everything else gets whitespace trimming on save. clangd needs a
`compile_commands.json` (`cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` or
`bear -- make`).

Debug adapters live in `~/.local/share/debug-adapters/`, shared with Emacs
dape: `make debug-adapters` fetches the java-debug plugin jar and the latest
`js-debug-dap` release. The Python adapter runs `python -m debugpy.adapter`
from `$VIRTUAL_ENV` or the project's `.venv`, resolved when the session
starts, so direnv applies. When the Java jar is present, `ftplugin/java.lua`
hands it to jdtls as a bundle and `<leader>Dc` offers the project's main
classes; without it, Java LSP still works and only debugging is unavailable.

Tree-sitter starts for any filetype with a compiled parser (the parser list
is in `packages.lua`), with folds (`foldlevelstart=99`, so open by default)
and tree-sitter indentation except for python and yaml, where Vim's indent
scripts are better.

## Claude Code

`claudecode.nvim` runs the Claude Code CLI in a right-hand split (native
terminal) and exposes Neovim over the same WebSocket MCP protocol the VS
Code extension uses: the selection, open buffers, diagnostics. Proposed
edits open as a vertical diff; edit the right-hand side if you like, then
`:w` or `<leader>aa` to accept, `:q` or `<leader>ad` to reject.

| Key | Action |
|---|---|
| `<leader>ac` / `af` | toggle / focus the Claude split |
| `<leader>ar` / `aC` | resume a session / continue the last one |
| `<leader>am` | select model |
| `<leader>ab` | add the current buffer to the context |
| `<leader>as` | send the visual selection; in netrw, add the file under the cursor |
| `<leader>aa` / `ad` | accept / deny the open diff |

Division of labor: tmux Claude for long autonomous runs; in-editor Claude
when the editor context pays off (tight edit-review loops, "fix the
diagnostic at point", selection-based questions). The two are separate
processes. One instance per nvim; the socket starts with nvim so a `claude`
launched in the split attaches to this editor.

## Theme

gruvbox (`contrast = "soft"`) in `theme.lua`. `:colorscheme` lists the
built-ins for a change of scene.

## Troubleshooting

- **No tree-sitter highlighting**: `:checkhealth nvim-treesitter`. The CLI
  (`tree-sitter-cli`), `curl`, `tar`, and a C compiler must be on PATH.
  `:TSInstall <lang>` for one parser, or `:lua
  require("nvim-treesitter").update()` for all.
- **Old plugins reappear or two completion menus**: leftovers in
  `~/.local/share/nvim/site/pack/packer` or `lazy`; `make doctor` warns,
  First launch step 2 removes them.
- **LSP not attaching**: `:checkhealth vim.lsp` and `:LspInfo`. Servers
  come from Homebrew, `make tools`, and (Julia) the Pkg step above.
- **jdtls slow or confused**: its workspace is
  `~/.cache/nvim/jdtls/<project>`; delete it to reindex.
- **Plugin trouble after an update**: `:checkhealth vim.pack`, then revert
  with the lockfile (Plugins above).
- **Claude split cannot find the CLI**: `:checkhealth claudecode`; it looks
  for `claude` on PATH.
