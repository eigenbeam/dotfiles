# Neovim Config + Kickstart Merge Design

**Date:** 2026-02-15
**Approach:** Additive merge — keep existing init.lua, add kickstart features in-place

## Decisions

- **Structure:** Single `nvim/nvim/init.lua` file (no modular split)
- **Plugin manager:** lazy.nvim (auto-bootstraps on first run)
- **Completion:** blink.cmp (kickstart's choice, Rust-powered)
- **Colorscheme:** Base2Tone-nvim with `base2tone_evening_dark`
- **Statusline:** mini.statusline (replaces custom Lua statusline)
- **Portability:** Plugins required — no graceful degradation. Remote machines use a separate minimal config.
- **LSP servers:** bashls, clangd, pyright, lua_ls (auto-installed via Mason)

## Plugins (16 total)

### Search & Navigation
- **telescope.nvim** + telescope-fzf-native + telescope-ui-select — fuzzy find files, grep, buffers, symbols, help, keymaps

### LSP & Tooling
- **mason.nvim** + mason-lspconfig + mason-tool-installer — auto-install LSP servers
- **nvim-lspconfig** — LSP client configuration
- **fidget.nvim** — LSP progress indicator
- **conform.nvim** — auto-format on save with LSP fallback

### Completion & Snippets
- **blink.cmp** — LSP-powered autocomplete
- **LuaSnip** — snippet engine

### Syntax & Editing
- **nvim-treesitter** — syntax highlighting, incremental selection
- **mini.nvim** (ai, surround, statusline) — text objects, surround operations, statusline
- **guess-indent.nvim** — auto-detect indentation

### Git & Visual
- **gitsigns.nvim** — git gutter signs, blame, hunk navigation
- **which-key.nvim** — keymap discovery
- **todo-comments.nvim** — highlight TODO/FIXME/NOTE

### Colorscheme
- **Base2Tone-nvim** — DuoTone EveningDark theme

## What Gets Removed

| Existing Code | Replaced By |
|---|---|
| `pcall(require, "lspconfig")` LSP block (lines 335-368) | Mason-managed LSP inside lazy.setup |
| Custom `_G.statusline()` function + `vim.opt.statusline` (lines 287-327) | mini.statusline |
| `colorscheme default` + custom highlight overrides (lines 436-444) | Base2Tone EveningDark |
| `vim.cmd("syntax on")` (line 142) | nvim-treesitter |
| `vim.opt.synmaxcol = 300` (line 136) | Irrelevant with Treesitter |

## What Stays Untouched

- VSCode Neovim block (lines 17-76)
- All core settings/options (lines 84-133, minus synmaxcol)
- `filetype plugin indent on` (line 143)
- Language-specific indent autocmds (lines 146-168)
- Custom filetype detection (lines 171-195)
- All existing keybindings except `<leader>f/g/b` (lines 198-271)
- Netrw configuration (lines 277-281)
- All quality-of-life autocmds: yank highlight, trailing whitespace removal, cursor position restore, ripgrep integration, auto-create parent dirs (lines 389-431)
- Clipboard diagnostic on VimEnter (lines 375-383)

## Keymap Changes

### Remapped (3 keys)

| Old | New | Reason |
|---|---|---|
| `<leader>f` → `:find ` | `<leader>sf` → Telescope find_files | Telescope replaces built-in |
| `<leader>g` → `:grep ` | `<leader>sg` → Telescope live_grep | Telescope replaces built-in |
| `<leader>b` → `:buffer ` | `<leader>sb` → Telescope buffers | Consistent `<leader>s` group |

### New Keymaps

**Telescope (`<leader>s` prefix):**
- `<leader>sh` — help tags
- `<leader>sk` — keymaps
- `<leader>sw` — grep current word
- `<leader>sd` — diagnostics
- `<leader>sr` — resume last search
- `<leader>s.` — recent files
- `<leader>sn` — search nvim config files
- `<leader>/` — fuzzy find in current buffer

**Conform:**
- `<leader>f` — format buffer (reuses freed-up key)

**Gitsigns:**
- `]h` / `[h` — next/prev git hunk
- `<leader>hs` — stage hunk
- `<leader>hr` — reset hunk
- `<leader>hb` — blame line

**LSP:**
- `<leader>th` — toggle inlay hints

## File Layout (top to bottom)

```
1.  Leader key setup
2.  lazy.nvim bootstrap
3.  lazy.setup({ ... }) — all 16 plugin specs with inline config
4.  if vim.g.vscode then ... end (VSCode block, unchanged)
5.  Core settings/options
6.  Filetype detection & language-specific autocmds
7.  Keybindings (existing preserved + new Telescope/gitsigns/conform)
8.  Netrw config
9.  Quality-of-life autocmds
```

Estimated: ~700-800 LOC.

## Theme Due Diligence

**Base2Tone-nvim:** Legitimate repo by Bram de Haan (atelierbram). 40 GitHub stars, pure Lua highlight definitions, zero attack surface. Last commit December 2022 — may need manual patches for newer Treesitter highlight groups.

**DuoTone for ADHD/eyes:** Theoretically sound (fewer competing colors = less visual noise, blue/purple tones noted as calming). No direct clinical studies on duotone syntax themes + ADHD. Accessibility research supports muted, low-saturation color palettes for attention challenges. Reasonable choice.
