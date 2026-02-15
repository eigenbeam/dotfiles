<!-- Print double-sided, cut along horizontal rules -->

# ═══════════════════════════════════════════════════
# CARD 1 — TMUX                              (FRONT)
# ═══════════════════════════════════════════════════

**Prefix: `C-a`** (Ctrl+A) · vi mode · mouse on · base index 1

## Sessions
```
tmux new -s name          New session
tmux ls                   List sessions
tmux attach -t name       Attach
tmux kill-session -t name Kill
```
| Key | Action |
|-----|--------|
| `C-a d` | Detach |
| `C-a s` | Session picker |
| `C-a $` | Rename session |

## Windows
| Key | Action |
|-----|--------|
| `C-a c` | New window |
| `C-a ,` | Rename window |
| `C-a &` | Kill window |
| `C-a p` / `C-a n` | Prev / next window |
| `C-a 1-9` | Jump to window N |
| `C-a w` | Window picker |

## Panes (pain-control plugin)
| Key | Action |
|-----|--------|
| `C-a \|` | Split vertical |
| `C-a -` | Split horizontal |
| `C-a x` | Kill pane |
| `C-h/j/k/l` | Navigate panes (crosses into nvim) |
| `M-h/j/k/l` | Resize panes (Alt+hjkl) |
| `C-a z` | Zoom/unzoom pane |
| `C-a {` / `C-a }` | Swap pane left / right |
| `C-a q` | Show pane numbers (then press # to jump) |

## Copy Mode (vi)
| Key | Action |
|-----|--------|
| `C-a [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Yank (copies to system clipboard via tmux-yank) |
| `q` or `Esc` | Exit copy mode |
| `/` or `?` | Search forward / backward |

---

# ═══════════════════════════════════════════════════
# CARD 1 — TMUX                               (BACK)
# ═══════════════════════════════════════════════════

## Plugins Installed
| Plugin | What It Does |
|--------|-------------|
| **tmux-pain-control** | `\|` `-` splits, `<` `>` `+` `-` resize |
| **tmux-yank** | `y` in copy mode → system clipboard |
| **tmux-copycat** | `C-a /` regex search, `C-a C-f` files, `C-a C-u` URLs |
| **tmux-open** | In copy mode: `o` opens selection, `S` searches DuckDuckGo |
| **tmux-resurrect** | `C-a C-s` save, `C-a C-r` restore sessions |
| **tmux-continuum** | Auto-saves/restores on tmux start |
| **tmux-logging** | `C-a P` toggle logging, `C-a M-p` screen capture |

## Command Mode
```
C-a :                     Enter command mode
:resize-pane -D 10        Resize down 10 rows
:swap-window -t 3         Move current window to position 3
:move-pane -t session:    Move pane to another session
:set synchronize-panes    Type in all panes simultaneously
:capture-pane -S -100     Capture last 100 lines
```

## Session Workflow
```
C-a (  /  C-a )           Switch to prev / next session
C-a L                     Last session (toggle)
```

## Troubleshooting
```
tmux source ~/.tmux.conf        Reload config
C-a I                           Install TPM plugins
tmux kill-server                Nuclear reset
tmux list-keys | grep <key>     Find binding
```

---

# ═══════════════════════════════════════════════════
# CARD 2 — NVIM: CORE                        (FRONT)
# ═══════════════════════════════════════════════════

**Leader: `Space`** · relative line numbers · scrolloff 8 · system clipboard

## Motion
| Key | Action |
|-----|--------|
| `h j k l` | Left, down, up, right |
| `w` / `b` | Next / prev word start |
| `e` / `ge` | Next / prev word end |
| `0` / `$` | Line start / end |
| `^` | First non-blank |
| `gg` / `G` | File start / end |
| `{` / `}` | Paragraph up / down |
| `%` | Matching bracket |
| `f{c}` / `F{c}` | Find char forward / backward (`;` `,` repeat) |
| `C-d` / `C-u` | Half-page down / up (auto-centered) |

## Editing
| Key | Action |
|-----|--------|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at line start / end |
| `o` / `O` | New line below / above |
| `x` | Delete char |
| `dd` / `cc` | Delete / change line |
| `dw` / `cw` | Delete / change word |
| `D` / `C` | Delete / change to end of line |
| `r{c}` | Replace char |
| `~` | Toggle case |
| `.` | Repeat last change |
| `u` / `C-r` | Undo / redo |

## Visual Mode
| Key | Action |
|-----|--------|
| `v` / `V` / `C-v` | Char / line / block visual |
| `<` / `>` | Indent (stays in visual) |
| `J` / `K` | Move selection down / up |
| `SPC p` | Paste without yanking over selection |

## Text Objects (`d/c/y` + object)
```
iw / aw       word                  i" / a"       double-quoted string
ip / ap       paragraph             i( / a(       parentheses
it / at       HTML tag              i{ / a{       braces
```

## mini.surround
| Key | Action |
|-----|--------|
| `sa{motion}{char}` | Add surround (`saiw"` → surround word with `"`) |
| `sd{char}` | Delete surround |
| `sr{old}{new}` | Replace surround |

---

# ═══════════════════════════════════════════════════
# CARD 2 — NVIM: CORE                         (BACK)
# ═══════════════════════════════════════════════════

## Registers & Macros
| Key | Action |
|-----|--------|
| `"ay` | Yank into register `a` |
| `"ap` | Paste from register `a` |
| `"+y` / `"+p` | System clipboard (also default) |
| `:reg` | Show all registers |
| `qa` | Record macro into `a` |
| `q` | Stop recording |
| `@a` | Play macro `a` |
| `@@` | Repeat last macro |
| `10@a` | Play macro 10 times |

## Marks
| Key | Action |
|-----|--------|
| `ma` | Set mark `a` |
| `` `a `` | Jump to mark `a` (exact) |
| `'a` | Jump to mark `a` (line) |
| `` `. `` | Last edit position |
| `` `` `` | Previous jump position |

## Command Mode
```
:s/old/new/g           Substitute in line
:%s/old/new/gc         Substitute in file (confirm each)
:g/pattern/d           Delete all lines matching pattern
:r !cmd                Insert command output
:!cmd                  Run shell command
:norm @a               Run macro on visual selection
```

## Splits & Buffers
| Key | Action |
|-----|--------|
| `SPC sv` | Vertical split |
| `SPC sh` | Horizontal split |
| `SPC se` | Equalize splits |
| `SPC sx` | Close split |
| `C-h/j/k/l` | Navigate splits (crosses into tmux) |
| `A-h/j/k/l` | Resize splits |
| `S-h` / `S-l` | Prev / next buffer |
| `SPC bd` | Delete buffer |

## Save & Quit
| Key | Action |
|-----|--------|
| `SPC w` | Save |
| `SPC q` | Quit |
| `SPC Q` | Force quit all |

---

# ═══════════════════════════════════════════════════
# CARD 3 — NVIM: LSP, SEARCH & GIT          (FRONT)
# ═══════════════════════════════════════════════════

**LSP: bashls, pyright, lua_ls, yamlls, ts_ls, terraformls, dockerls, taplo, julials, jdtls** · **Completion: blink.cmp**

## LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `SPC rn` | Rename symbol |
| `SPC ca` | Code action |
| `SPC d` | Diagnostics float |
| `[d` / `]d` | Prev / next diagnostic |
| `SPC th` | Toggle inlay hints |
| `SPC f` | Format buffer (conform.nvim) |

## Completion (blink.cmp)
```
<C-Space>     Trigger completion
<C-n>/<C-p>   Next / prev item
<C-y>         Accept
<C-e>         Cancel
<C-f>/<C-b>   Scroll docs
```

## Telescope Search (`SPC s` prefix)
| Key | Action |
|-----|--------|
| `SPC sf` | Find files |
| `SPC sg` | Live grep |
| `SPC sw` | Grep current word |
| `SPC sb` | Buffers |
| `SPC s.` | Recent files |
| `SPC s?` | Help tags |
| `SPC sk` | Keymaps |
| `SPC sd` | Diagnostics |
| `SPC sr` | Resume last search |
| `SPC sn` | Search nvim config |
| `SPC /` | Fuzzy find in current buffer |

**Inside Telescope:** `C-n`/`C-p` navigate, `<CR>` select, `<Esc>` close, `C-x` split, `C-v` vsplit

## Git via Telescope
| Key | Action |
|-----|--------|
| `SPC gc` | Git commits |
| `SPC gf` | Git file history |
| `SPC gs` | Git status |

---

# ═══════════════════════════════════════════════════
# CARD 3 — NVIM: LSP, SEARCH & GIT           (BACK)
# ═══════════════════════════════════════════════════

## Gitsigns (hunks)
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev hunk |
| `SPC hs` | Stage hunk |
| `SPC hr` | Reset hunk |
| `SPC hb` | Blame line |
| `SPC hd` | Diff against index |
| `SPC hD` | Diff against last commit |

## Lint (nvim-lint)
| Key | Action |
|-----|--------|
| `SPC ll` | Lint current file |

Auto-lints on save. Linters: ruff (python), eslint (js/ts), tflint (terraform).

## Debug (nvim-dap)
| Key | Action |
|-----|--------|
| `SPC Db` | Toggle breakpoint |
| `SPC Dc` | Continue |
| `SPC Do` | Step over |
| `SPC Di` | Step into |
| `SPC Du` | Toggle DAP UI |

## Toggles
| Key | Action |
|-----|--------|
| `SPC tz` | Zen mode |
| `SPC tt` | Terminal (horizontal split) |

## which-key
Press `SPC` and wait — shows all leader bindings grouped by category.

## Plugin Management
```
:Lazy                  Open lazy.nvim UI
:Lazy sync             Update all plugins
:Lazy health           Check plugin health
:checkhealth           Nvim diagnostic check
```

## Treesitter
Installed: bash, c, cpp, css, diff, dockerfile, hcl, html, java, javascript,
json, julia, lua, markdown, python, sql, terraform, toml, tsx, typescript,
vim, yaml. Context headers (3 lines max) show enclosing function/class.

## Formatting (conform.nvim)
Formats on save. lua: stylua, python: ruff, js/ts/json/yaml/md: prettier,
terraform: terraform_fmt, toml: taplo. `SPC f` to format manually.

---

# ═══════════════════════════════════════════════════
# CARD 4 — CLI TOOLS (modern replacements)   (FRONT)
# ═══════════════════════════════════════════════════

**Aliases active:** `cat→bat` `ls→eza` `vi/vim→nvim`

## bat (cat replacement) — syntax highlighting, git integration
```
bat file.py                  View with syntax + line numbers
bat -l json                  Force language
bat -p file.py               Plain (no line numbers/header)
bat -A file                  Show non-printable chars
bat --diff file              Show git diff inline
bat -r 10:20 file            Lines 10-20 only
```
Also used as: `MANPAGER` (man pages with highlighting)

## eza (ls replacement) — icons, git status, tree
```
ls                           eza (aliased)
ll                           eza -la --git --icons
lt                           eza --tree --level=2 --icons
eza -la --sort=modified      Sort by modified
eza -la --sort=size          Sort by size
eza --git-ignore             Respect .gitignore
```

## fd (find replacement) — fast, respects .gitignore
```
fd pattern                   Find files matching pattern
fd -e py                     Find by extension
fd -t d                      Directories only
fd -t f                      Files only
fd -H                        Include hidden
fd -I                        Don't respect .gitignore
fd pattern --exec cmd {}     Run command on each result
fd -e log --changed-within 1d  Modified in last day
```

## ripgrep / rg (grep replacement) — fast, .gitignore aware
```
rg pattern                   Search recursively
rg pattern -t py             Only Python files
rg pattern -g '*.yaml'       Glob filter
rg -i pattern                Case insensitive
rg -w pattern                Whole word
rg -l pattern                Files only (no content)
rg -c pattern                Count matches per file
rg -C 3 pattern              3 lines context
rg --no-ignore pattern       Search gitignored files too
rg -F 'literal.string'       Fixed string (no regex)
```

## fzf (fuzzy finder)
```
C-t                          Fuzzy file picker (insert into command)
C-r                          Fuzzy history search
M-c                          Fuzzy cd into directory (Alt+C)
vim $(fzf)                   Open selected file in nvim
rg pattern | fzf             Filter grep results interactively
```
**Backend:** `rg --files --hidden` for files, `fd --type d` for dirs

---

# ═══════════════════════════════════════════════════
# CARD 4 — CLI TOOLS (modern replacements)    (BACK)
# ═══════════════════════════════════════════════════

## jq (JSON processor)
```
jq '.'                       Pretty-print
jq '.key'                    Extract key
jq '.items[0]'               First array element
jq '.items[] | .name'        Map over array
jq 'select(.age > 30)'      Filter
jq -r '.name'                Raw output (no quotes)
jq -c '.'                    Compact output
jq 'keys'                    Get all keys
jq 'length'                  Count items
cat file.json | jq '.a.b'   Pipe into jq
```

## xh (curl alternative) — colorized, HTTPie-like syntax
```
xh httpbin.org/get           GET (default)
xh POST url key=val          POST JSON
xh POST url key:=123         POST with int (`:=` for non-string)
xh -f POST url key=val       Form POST
xh url Authorization:Bearer\ tok  Custom header
xh -d url                    Download file
xh --offline POST url k=v    Preview request (don't send)
```

## zoxide (cd replacement) — learns your directories
```
z dotfiles                   Jump to most-used match
z dot                        Partial match works
zi                           Interactive picker (fzf)
z -                          Previous directory
```

## direnv — per-project environment
```
# Create .envrc in project root:
export DATABASE_URL=...
direnv allow                 Trust the .envrc
direnv deny                  Revoke trust
# Auto-loads/unloads on cd in/out
```

## tldr — simplified man pages
```
tldr tar                     Quick examples for tar
tldr --update                Update local cache
```

## make — your dotfiles use it
```
make                         Stow all configs
make homebrew                Install core packages
make tools                   npm + uv tool installs
make ssh                     Deploy SSH config
```

---

# ═══════════════════════════════════════════════════
# CARD 5 — GIT                               (FRONT)
# ═══════════════════════════════════════════════════

**Pager: delta (side-by-side)** · **Pull: rebase** · **Merge: zdiff3**

## Your Aliases
```
git st           status              git br           branch
git sts          status --short      git ci           commit
git co           checkout            git prev         switch to last branch
git hist         pretty log graph    git unstage      restore --staged
git amend        commit --amend      git undo         reset --soft HEAD~1
```

## Basics
```
git init                     New repo
git clone url                Clone repo
git add file                 Stage file
git add -p                   Stage interactively (hunk by hunk)
git ci -m "msg"              Commit
git push -u origin branch    Push new branch
git pull                     Pull + rebase (your config)
```

## Branching
```
git br                       List branches
git co -b feature            New branch from current
git switch main              Switch to main
git prev                     Toggle last branch
git br -d branch             Delete merged branch
git br -D branch             Force delete branch
```

## Inspecting
```
git st                       Status
git diff                     Unstaged changes (delta: side-by-side)
git diff --staged            Staged changes
git hist                     Pretty log graph
git log --oneline -20        Last 20 commits
git show abc123              Show a commit
git blame file               Line-by-line authorship
git log -p -- file           History of a file
```

## Stashing
```
git stash                    Stash changes
git stash pop                Restore + remove stash
git stash list               List stashes
git stash show -p            Show stash contents
git stash drop               Delete top stash
```

---

# ═══════════════════════════════════════════════════
# CARD 5 — GIT                                (BACK)
# ═══════════════════════════════════════════════════

## Rebase (auto-stash + auto-squash enabled)
```
git rebase main              Rebase onto main
git rebase --continue        After resolving conflicts
git rebase --abort           Cancel rebase
```
Auto-stash means dirty worktree is OK — git stashes/restores for you.

## Undoing Things
```
git unstage file             Unstage a file (your alias)
git undo                     Undo last commit, keep changes staged
git amend                    Amend last commit (no message edit)
git checkout -- file         Discard unstaged changes to file
git revert abc123            Create commit that undoes abc123
git reset --soft HEAD~3      Undo last 3 commits, keep changes staged
git reset --mixed HEAD~1     Undo commit + unstage (keep files)
```

## Merge Conflicts (zdiff3 style)
```
<<<<<<< HEAD (yours)
your changes
||||||| (original — zdiff3 shows this)
what it was before
=======
their changes
>>>>>>> branch
```
zdiff3 shows the **original text** between the two versions — much easier to resolve.

## GitHub CLI (gh)
```
gh pr create                 Create PR interactively
gh pr view                   View current branch PR
gh pr list                   List open PRs
gh pr checkout 123           Check out PR #123
gh issue list                List issues
gh issue create              Create issue
gh repo clone user/repo      Clone
gh browse                    Open repo in browser
```

## Cherry-Pick & Bisect
```
git cherry-pick abc123       Apply a commit to current branch
git bisect start             Start binary search for bug
git bisect bad               Current commit is bad
git bisect good abc123       That commit was good
git bisect reset             Done bisecting
```

## Useful Patterns
```
git log --all --oneline --graph   Visual branch topology
git diff main...HEAD              What this branch changed
git log main..HEAD                Commits since branching from main
git reflog                        Undo anything — find lost commits
```

---

# ═══════════════════════════════════════════════════
# CARD 6 — TUI TOOLS                         (FRONT)
# ═══════════════════════════════════════════════════

## lazygit — full git TUI (`SPC gg` from nvim)
```
Panels: 1=Status 2=Files 3=Branches 4=Commits 5=Stash
```
| Key | Action |
|-----|--------|
| `Space` | Stage / unstage |
| `a` | Stage all |
| `c` | Commit |
| `C` | Commit with editor |
| `P` / `p` | Push / pull |
| `Enter` | Expand / view diff |
| `d` | Discard changes (file panel) |
| `s` | Squash commit (commits panel) |
| `r` | Reword commit |
| `R` | Rebase |
| `M` | Merge |
| `Space` | Cherry-pick (commits panel) |
| `/` | Filter |
| `+` / `-` | Expand / collapse diff context |
| `?` | Help |
| `q` | Quit |

## yazi — file manager TUI (modal, vim-like)
```
yazi                         Open file manager
yazi <path>                  Open at path
```
| Key | Action |
|-----|--------|
| `h` / `l` | Parent / enter directory |
| `j` / `k` | Move down / up |
| `Enter` | Open file |
| `Space` | Select item |
| `/` | Search |
| `n` / `N` | Next / prev search match |
| `o` | Open with system default |
| `y` / `p` / `d` / `x` | Yank / paste / delete / cut |
| `a` | Create file |
| `r` | Rename |
| `.` | Toggle hidden files |
| `z` | Jump (zoxide integration) |
| `~` | Home |
| `q` | Quit |
| `Tab` | Switch pane |

---

# ═══════════════════════════════════════════════════
# CARD 6 — TUI TOOLS                          (BACK)
# ═══════════════════════════════════════════════════

## bottom (btm) — system monitor TUI (top replacement)
```
btm                          Launch
```
| Key | Action |
|-----|--------|
| `e` | Expand selected widget |
| `h/j/k/l` or arrows | Navigate |
| `/` | Process search |
| `Tab` | Cycle widgets |
| `dd` | Kill selected process |
| `c` | Sort by CPU |
| `m` | Sort by memory |
| `p` | Sort by PID |
| `t` | Tree view |
| `s` | Cycle sort |
| `?` | Help |
| `q` | Quit |

**Flags:** `btm --battery` show battery, `btm -b` basic mode

## glow — markdown renderer TUI
```
glow file.md                 Render single file
glow                         Browse markdown files (stash)
glow -p file.md              Pager mode (scrollable)
glow -w 80 file.md           Set width
```

## lazydocker — Docker TUI
| Key | Action |
|-----|--------|
| `e` | Exec shell into container |
| `d` | Remove container |
| `s` | Stop container |
| `r` | Restart container |
| `a` | Attach to container |
| `[` / `]` | Previous / next tab |
| `/` | Filter |
| `q` | Quit |

## shellcheck — shell script linter
```
shellcheck script.sh         Lint a script
shellcheck -e SC2086         Exclude specific rule
shellcheck -f diff           Output as diff (auto-fixable)
shellcheck -s bash           Force shell dialect
```
Common codes: `SC2086` unquoted variable, `SC2046` unquoted subshell, `SC2155` declare+assign

## delta — git diff pager (auto-configured)
Your git is configured to use delta with side-by-side + line numbers.
```
delta file1 file2            Diff two files directly
git diff | delta             Manual pipe (usually automatic)
```
Navigation: `n`/`N` next/prev file, `/` search, `q` quit (same as less)

---

# ═══════════════════════════════════════════════════
# CARD 7 — ZSH & SHELL                       (FRONT)
# ═══════════════════════════════════════════════════

**Shell: zsh** · **Prompt: starship** · **Plugins: autosuggestions, syntax-highlighting**

## Navigation
| Key | Action |
|-----|--------|
| `C-a` / `C-e` | Line start / end |
| `M-b` / `M-f` | Word back / forward (Alt+b/f) |
| `C-w` | Delete word backward |
| `M-d` | Delete word forward |
| `C-u` | Delete to line start |
| `C-k` | Delete to line end |
| `C-y` | Paste deleted text |
| `C-r` | Fuzzy history search (fzf) |
| `C-t` | Fuzzy file picker (fzf) |
| `M-c` | Fuzzy cd (fzf, uses fd) |
| `Tab` | Complete (menu-select, includes hidden files) |
| `→` | Accept autosuggestion |
| `M-→` | Accept next word of suggestion |

## History (8192 entries, shared across sessions)
```
!!                           Repeat last command
!$                           Last argument of last command
!abc                         Last command starting with "abc"
!abc:p                       Print (don't execute) ^
history | rg pattern         Search history
```

## Job Control
```
C-z                          Suspend foreground job
bg                           Resume in background
fg                           Resume in foreground
jobs                         List background jobs
kill %1                      Kill job 1
```

## Process Management
```
cmd &                        Run in background
cmd1 && cmd2                 Run cmd2 if cmd1 succeeds
cmd1 || cmd2                 Run cmd2 if cmd1 fails
cmd1 | cmd2                  Pipe stdout
cmd1 |& cmd2                 Pipe stdout+stderr
cmd > file                   Redirect stdout
cmd 2>&1                     Redirect stderr to stdout
cmd &> file                  Redirect all to file
cmd >> file                  Append
```

---

# ═══════════════════════════════════════════════════
# CARD 7 — ZSH & SHELL                        (BACK)
# ═══════════════════════════════════════════════════

## Zsh Globbing (more powerful than bash)
```
**/*.py                      Recursive glob
*.txt~README*                Exclude pattern
*(.)                         Regular files only
*(/)                         Directories only
*(om[1,5])                   5 most recently modified
*(Lk+100)                    Files > 100KB
*(@)                         Symlinks only
```

## Parameter Expansion
```
${var:-default}              Default if unset
${var:=default}              Assign default if unset
${var#pattern}               Remove shortest prefix
${var##pattern}              Remove longest prefix
${var%pattern}               Remove shortest suffix
${var%%pattern}              Remove longest suffix
${var/old/new}               Replace first
${var//old/new}              Replace all
${var:u}                     Uppercase (zsh)
${var:l}                     Lowercase (zsh)
${#var}                      Length
```

## Useful Builtins
```
type cmd                     What is this command?
which cmd                    Path to command
where cmd                    All locations
whence -v cmd                Verbose type info
command cmd                  Bypass aliases/functions
source file                  Execute file in current shell
exec cmd                     Replace shell with cmd
```

## Environment
```
env                          Show all env vars
export KEY=val               Set env var
unset KEY                    Remove env var
printenv KEY                 Print one var
```

## Keyboard Note
Right Option is remapped to Control (via hidutil). So `Right-Opt + h` = `C-h`.

## Quick Reference
| Old | New (aliased) |
|-----|---------------|
| `cat` | `bat --paging=never` |
| `ls` | `eza` |
| `ll` | `eza -la --git --icons` |
| `lt` | `eza --tree --level=2 --icons` |
| `vi` / `vim` | `nvim` |
| `man` | via `bat` (syntax highlighted) |
| `cd` | `z` (zoxide — learns) |
| `grep` | `rg` (ripgrep) |
| `find` | `fd` |
