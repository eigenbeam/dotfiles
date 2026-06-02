# Emacs Configuration Review & Modernization Plan

## Context

The Emacs config (`emacs/dot-emacs.d/`, ~750 lines of elisp across `init.el` +
5 `lisp/*.el` modules) was last meaningfully touched when it was re-added as a
stow package, and hasn't had a thorough pass in a while. It runs on **Emacs
30.2** (emacs-plus, NS build) but its comments still target "Emacs 29+", and it
predates several things Emacs 30 now does better or built-in.

This plan does three things: (1) fix confirmed bugs — most importantly a silent
Eglot/tree-sitter breakage; (2) modernize the stack to match the minad-centric
minibuffer setup already in place, favoring built-ins and well-adopted packages;
(3) cut stale, partly-inaccurate documentation. All changes are matched to the
stated preferences: low-distraction, low-bling, minimalist, but high "devpower"
— adopting new things only where they are clearly better and widely used.

The aggressive scope (corfu, project.el, vundo, electric-pair, flymake, plus
embark/diff-hl/session-memory) was chosen by the user during review.

The plan was then extended (section E) to cover **using Claude Code efficiently
inside Emacs**. The user is a heavy terminal Claude Code user (Ghostty + tmux +
Neovim outside Emacs) and wants an equally efficient in-editor experience. The
current config carries homegrown vterm glue for this; section E replaces it with
a maintained, MCP-aware package that fits the migrated stack.

---

## Evaluation summary

| Dimension | Verdict |
|---|---|
| **Quality** | Solid, well-organized, idiomatic `use-package`. Clean module split. |
| **Bugs** | One serious (Eglot won't start in tree-sitter buffers); two minor (inert mac-modifier vars; global `delete-trailing-whitespace` leaking out of prog-mode). |
| **Redundancy** | `flycheck` duplicates eglot's flymake; `projectile` duplicates built-in project.el; in-buffer `company` is stylistically off from the minad minibuffer stack. |
| **Consistency** | Mixed comment style (`;` vs `;;`); tab-indented blocks violate the repo's 4-space `.editorconfig`; docs contradict code (theme + completion engine). |
| **Simplicity** | Good overall. The mid-session archive-refresh advice in `init.el` is more machinery than most configs carry, but solves a real 404 problem — keep. |
| **Devpower** | Strong foundation (eglot, dap, magit/forge, consult, treesit) but missing the cheap high-value layer: session memory, embark, `consult-line`, VC fringe. |
| **Modernity** | Behind Emacs-30 defaults: not using built-in which-key, flymake, project.el, `completion-preview`/corfu, save-place/savehist. |

---

## Confirmed bugs (verified empirically against Emacs 30.2)

1. **Eglot never auto-starts in tree-sitter buffers (serious).**
   `dev.el` hooks `eglot-ensure` on `python-mode`, `js-mode`, `java-mode`,
   `c-mode`, `c++-mode`, `sh-mode`. But `treesit-auto` + `global-treesit-auto-mode`
   remap files to `python-ts-mode`, `js-ts-mode`, etc. once a grammar is
   installed. Emacs 30's `derived-mode-extra-parents` makes `python-ts-mode`
   *report* as derived from `python-mode` (so `derived-mode-p` passes) **but does
   not run `python-mode-hook`**. Verified: entering a mode with an extra-parent
   ran only its own hook, not the parent's. Net effect: install a grammar →
   Eglot silently stops launching for that language. Inconsistent today (depends
   on whether each grammar is installed), fully broken once grammars exist.

2. **`mac-*-modifier` settings are inert on emacs-plus.** `basics.el` sets
   `mac-command-modifier`/`mac-option-modifier`/`mac-right-option-modifier`.
   Those belong to the *emacs-mac* (Mitsuharu) port. emacs-plus is the NS build,
   which reads `ns-*-modifier`. The variables are technically bound but the NS
   port ignores them. (The `keyboard` stow package already remaps right-option →
   right-control at the OS level, so that intent is satisfied regardless.)

3. **`delete-trailing-whitespace` leaks to a global hook.** Inside
   `prog-mode-hook`, `(add-hook 'before-save-hook 'delete-trailing-whitespace)`
   has no LOCAL arg, so it registers on the *global* `before-save-hook` the first
   time any prog buffer opens — then strips trailing whitespace on save in *every*
   buffer, including Markdown (clobbering trailing-space hard line breaks) and Org.

4. **Docs contradict code.** `THEME-GUIDE.md` states the default theme is
   `modus-operandi` (it's `gruvbox-dark-soft`). `EGLOT-DAP-CHEATSHEET.md`
   ("Generated … 2025") recommends `pip install python-lsp-server` (you use
   ruff/uv), references `company`/`node-debug2`, etc. Both are large, AI-shaped,
   and drifting.

---

## Update plan

Changes are grouped by intent. File targets are named; representative elisp is
shown for the non-obvious pieces. Keep every built-in opt-out (`:ensure nil`)
and the existing `use-package` + `:diminish` conventions.

### A. Correctness fixes

**`lisp/dev.el` — fix the Eglot hook (the important one).** Replace the
classic-mode hook list with one covering both classic and `-ts-` variants:

```elisp
:hook (((python-mode python-ts-mode
         js-mode js-ts-mode
         java-mode java-ts-mode
         c-mode c-ts-mode
         c++-mode c++-ts-mode
         sh-mode bash-ts-mode) . eglot-ensure))
```

**`lisp/basics.el` — port modifier vars to the NS port** (documents intent and
is correct for emacs-plus; harmless alongside the OS-level remap):

```elisp
(setq ns-command-modifier 'meta)
(setq ns-option-modifier nil)
(setq ns-right-option-modifier 'control)
```

**`lisp/basics.el` — scope trailing-whitespace deletion to the buffer** by adding
the LOCAL flag so it stays inside prog-mode:

```elisp
(add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
```

### B. Stack modernization (swaps)

**`company` → `corfu` + `cape`** (`lisp/packages.el`). Remove the `company`
block; add:

```elisp
(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  :config (corfu-popupinfo-mode))   ; doc popup, replaces company tooltip annotations

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))
```

In the `orderless` block in `basics.el`, let eglot completion use orderless
(eglot otherwise forces its own style):

```elisp
(completion-category-overrides
 '((file (styles basic partial-completion))
   (eglot (styles orderless))
   (eglot-capf (styles orderless))))
```

**`flycheck` → built-in `flymake`** (`lisp/packages.el`). Remove the `flycheck`
block entirely — eglot drives `flymake` automatically. Add jump bindings (or rely
on `consult-flymake` from section C):

```elisp
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
         ("M-g n" . flymake-goto-next-error)
         ("M-g p" . flymake-goto-prev-error)))
```

**`smartparens` → built-in `electric-pair-mode`** (`lisp/packages.el`). Remove
the `smartparens` block; in `basics.el` add `(electric-pair-mode 1)` and keep
`(show-paren-mode 1)`. `rainbow-delimiters` stays.

**`undo-tree` → `vundo`** (`lisp/packages.el`). Remove the `undo-tree` block
(and its history-dir config); add:

```elisp
(use-package vundo
  :bind ("C-x u" . vundo))   ; built-in undo otherwise; vundo only visualizes
```

**`projectile` → built-in `project.el`** (`lisp/packages.el`). Remove the
`projectile` block. project.el is what eglot/consult already use; preserve the
`C-c p` muscle memory and the dired-on-switch behavior:

```elisp
(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map)
  :custom (project-switch-commands 'project-dired))
```

`consult`'s `C-x p b` binding already targets project.el. Two follow-ons:
- `lisp/dev.el`: change `poetry-tracking-strategy` off projectile →
  `(setq poetry-tracking-strategy 'switch-buffer)`.
- **Recommended (optional):** drop `poetry.el` altogether. Your global tooling
  standard is `uv`, not Poetry; `pyvenv` already handles venv activation. Removing
  it also removes the last projectile consumer cleanly. Left in by default since
  you may still open Poetry repos — flagging the mismatch.

### C. Additions (devpower, low-bling)

**Session memory** (`lisp/basics.el`, built-in, near-zero cost):

```elisp
(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(save-place-mode 1)
```

**`embark` + `embark-consult`** (`lisp/packages.el`):

```elisp
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))
```

**`consult-line` + `consult-flymake`** — add to the existing `consult` `:bind`
in `basics.el`:

```elisp
("M-s l" . consult-line)
("M-g f" . consult-flymake)
```

**`diff-hl`** — VC changes in the (already-widened) fringe (`lisp/packages.el`):

```elisp
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config (diff-hl-flydiff-mode))   ; update without needing a save
```

### D. Docs + housekeeping (lower priority, do last)

- **`THEME-GUIDE.md`**: correct the default-theme claim (gruvbox-dark-soft) or,
  preferably, slim the 309-line guide to a short "switch with `M-x load-theme`;
  default is gruvbox-dark-soft" note. The migration to Gruvbox is already done.
- **`EGLOT-DAP-CHEATSHEET.md`**: fix the language-server install commands
  (ruff/uv, not pylsp), drop `company`/`node-debug2` references, or trim to a
  one-screen keybinding card. 400 lines of AI-shaped prose is maintenance debt.
- **`init.el`**: remove the now-unused `("org" . orgmode.org/elpa)` archive
  (org is `:ensure nil`); optionally drop the `use-package` self-install block
  (built-in on Emacs 30).
- **`lisp/packages.el`**: set `which-key` to `:ensure nil` — it's bundled with
  Emacs 30.
- **Style sweep:** normalize stray single-`;` comments to `;;`, and re-indent the
  tab-indented `prog-mode-hook`/`kwb-dev-mode-hook` blocks to 4 spaces per the
  repo `.editorconfig`.
- **Optional low-distraction nicety:** `(pixel-scroll-precision-mode 1)` for
  smooth trackpad scrolling on macOS. Consider whether the fixed
  `(set-frame-size … 120 60)` on every launch is still wanted.

### E. Claude Code in Emacs (terminal-power user → in-editor)

Replace the homegrown vterm Claude glue with **`claude-code-ide.el`** (manzaltu)
— the most-adopted Emacs CC integration (~1.6k★) and the best fit for the stack
this plan moves to: it is `project.el`-native and exposes Emacs tools to Claude
over MCP, so the eglot/flymake/treesit migrations directly feed it.

In `lisp/packages.el`, **remove** `my-claude-code`, `my-send-region-to-claude`,
and their `C-c C` / `C-c >` bindings. **Keep** the `vterm` package — it stays as
a plain terminal (`C-c t`) and as claude-code-ide's terminal backend (its
default). Add:

```elisp
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))   ; expose xref/diagnostics/ediff/imenu to Claude
```

vterm is the default backend (no extra config); `eat` and `ghostel` are also
supported via customize. `C-c C-'` avoids every other prefix this plan uses
(`C-c a/c/l/g/p/t/d`).

Problems in the current homegrown setup that this fixes:
- the `0.5s` init timer is a race — the package owns the terminal lifecycle.
- `my-send-region-to-claude` sends embedded newlines as Enter keypresses, which
  mangles multi-line code in Claude's TUI; MCP selection sharing replaces it.
- no project awareness / window management / restart handling — the package is
  `project.el`-native with one instance per project.
- the homegrown terminal is "blind"; the MCP tools give Claude xref/treesit/
  imenu/diagnostics access and route edits through `ediff` for review.

Workflow note (heavy tmux user): this does **not** replace tmux CC. Keep tmux CC
for long autonomous runs; use in-Emacs CC for tightly-coupled editing where the
MCP callbacks pay off (ediff review, jump-to-diagnostic, send-selection).
Separate processes — no conflict.

Backend note: `vterm` is the pragmatic default (already compiled). Since you live
in Ghostty, the `ghostel` (libghostty) backend renders the Claude TUI most
faithfully and is worth trying — newer, so adopt after the vterm baseline works.

**Decision point:** the alternative is stevemolitor's `claude-code.el` (~700★,
`eat` default) + its `monet` add-on for diffs/selection — comparable quality,
terminal-menu-centric, slightly less Emacs-awareness out of the box. This plan
defaults to `claude-code-ide.el`; swap if you prefer the menu ergonomics.

---

## Critical files

- `emacs/dot-emacs.d/lisp/dev.el` — Eglot hook fix; poetry strategy.
- `emacs/dot-emacs.d/lisp/packages.el` — corfu/cape, flymake, electric-pair,
  vundo, project.el, embark, diff-hl; remove company/flycheck/smartparens/
  undo-tree/projectile; which-key `:ensure nil`. Also (section E): remove the
  homegrown `my-claude-code`/`my-send-region-to-claude`; add `claude-code-ide`;
  keep `vterm` as plain terminal + CC backend.
- `emacs/dot-emacs.d/lisp/basics.el` — ns-modifiers, before-save-hook scope,
  orderless eglot override, session-memory modes, electric-pair-mode,
  consult-line/consult-flymake binds.
- `emacs/dot-emacs.d/init.el` — drop org archive; optional use-package block.
- `emacs/dot-emacs.d/THEME-GUIDE.md`, `EGLOT-DAP-CHEATSHEET.md` — correct/trim.

No `Brewfile` changes needed (`fd`, `ripgrep`, `jdtls`, `node`, emacs-plus all
present). Tree-sitter grammars install on demand via `treesit-auto`'s prompt.

---

## Verification

Do the work on a branch; verify before committing.

1. **Byte-compile clean:** `emacs --batch -f batch-byte-compile lisp/*.el` (run
   from `emacs/dot-emacs.d/`) — expect no errors; warnings acceptable.
2. **Clean startup:** launch a fresh GUI Emacs, confirm no `*Warnings*`/error on
   init and that packages install. `M-x use-package-report` (statistics are on)
   to confirm load.
3. **Eglot + tree-sitter (the key fix):** open a `.py` file, accept the
   tree-sitter grammar prompt so the buffer is `python-ts-mode` (check with
   `C-h v major-mode`), and confirm the mode-line shows Eglot connected and
   `M-.`/completion work. Repeat for a `.js` and a `.java` file. This is the
   regression that motivated the plan.
4. **Completion:** type in a code buffer — corfu popup appears; `corfu-popupinfo`
   shows docs; orderless filtering works on eglot candidates.
5. **Diagnostics:** introduce an error — flymake underlines it; `M-g n`/`M-g p`
   and `M-g f` (consult-flymake) navigate to it. Confirm no leftover flycheck.
6. **Swaps:** `C-x u` opens vundo; typing `(` auto-inserts `)` (electric-pair);
   `C-c p` opens the project map and `C-x p b` lists project buffers; a git repo
   shows change bars in the fringe (diff-hl).
7. **Additions:** `C-.` (embark-act) on a minibuffer candidate; `M-s l`
   (consult-line); reopen a file and confirm point is restored (save-place) and
   recent files appear in `consult-buffer` (recentf).
8. **Bug-fix spot checks:** save a Markdown file with intentional trailing
   double-spaces — they survive (whitespace deletion no longer global); confirm
   right-option still behaves as control.
9. **Lint/format:** run the repo's `make lint` (touches bash only, but confirms
   no repo-wide breakage) and ensure `.el` indentation matches `.editorconfig`.
10. **Claude Code in Emacs (section E):** `C-c C-'` opens the claude-code-ide
    menu; start a session inside a project and confirm one instance per project;
    select a region and confirm Claude receives it; have Claude propose an edit
    and confirm it opens in `ediff` for review; ask something needing a
    definition or diagnostic and confirm the MCP tools respond. Confirm the old
    `C-c C` / `C-c >` bindings are gone and `C-c t` still opens a plain vterm.
