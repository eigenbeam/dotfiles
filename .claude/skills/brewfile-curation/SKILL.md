---
name: brewfile-curation
description: Audit and curate the Homebrew Brewfile in this dotfiles repo — categorize packages under section headers, flag removal candidates, recommend tools matched to the user's profile, and reconcile the Brewfile against what is actually installed. Use when asked to review, audit, clean up, categorize, prune, or sync the Brewfile or Homebrew packages.
---

# Brewfile curation

Curate `homebrew/Brewfile` — the single, hand-maintained list of Homebrew
packages for this dotfiles repo (shared across macOS and Linux/Linuxbrew).

## Hard rules

- **Never run `brew bundle dump` or `make brewfile` to regenerate the file.**
  It clobbers the curated list with a raw flat dump that includes every
  transitive dependency. Edit `homebrew/Brewfile` by hand.
- **No transitive dependencies as entries.** Only packages the user
  explicitly wants belong in the Brewfile; Homebrew pulls in deps itself.
- **One file, organized by category comments.** There is no `Brewfile.extras`.
- **Install or uninstall nothing until the user has approved it.** Present the
  audit, let the user decide package-by-package, then apply.

## The user's profile (drives keep / cut / recommend calls)

- Terminal-centric workflow: ghostty + tmux + neovim and CLI tools. Favors
  fast, low-friction, low-dependency tools. ADHD; uses computer + reading
  glasses — clarity and low cognitive load matter.
- Day job: Python, Java, JavaScript/TypeScript, Terraform, Docker, AWS,
  data-processing pipelines, SSH to EC2, data analysis/visualization, geospatial.
- Also: Lean/Mathlib, Julia, Mathematica, Octave, SQL/PostgreSQL/PostGIS.
- Python is managed with `uv` — not pyenv or pip.
- Runs on macOS (MacBook Air M2) and Linux. Casks are macOS-only.

## Procedure

### 1. Gather ground truth
- Read `homebrew/Brewfile`.
- `brew leaves --installed-on-request` — packages the user explicitly asked for.
- `brew leaves` — installed packages nothing else depends on.
- `brew bundle check --file=homebrew/Brewfile --verbose` — missing vs. satisfied.

### 2. Cross-reference
- **Brewfile entry NOT in `brew leaves --installed-on-request`** → likely a
  transitive dependency that crept in. Flag for removal from the Brewfile.
- **`installed-on-request` package NOT in the Brewfile** → either a deliberate
  omission or a missing entry. Surface it and ask.
- Note anything `brew bundle check` reports as missing.

### 3. Categorize
Group every entry under `#`-comment section headers, `brew` then `cask` within
each section, sorted alphabetically. The Brewfile may currently be a flat list —
establishing the structure is part of the job. A reasonable taxonomy (adapt to
what is actually present):

`Shell & terminal` · `Editor & language servers` · `Languages & runtimes` ·
`Git & VCS` · `Search & file tools` · `Cloud & DevOps` · `Data & databases` ·
`Geospatial & scientific` · `Security & secrets` · `Media & misc` · `Fonts` ·
`Casks (GUI apps, macOS)`

### 4. Flag removal candidates
For each, give a one-line reason: superseded by another tool, duplicate
purpose, unused for the user's stack, or a transitive dep. Don't pad — only
flag what you can defend.

### 5. Recommend additions
Suggest missing or better tools, matched to the profile and evidence-based. Be
conservative: a short, justified list, not a wishlist.

### 6. Present, decide, apply
Show the audit grouped by category, with removals and additions clearly marked.
Let the user accept or reject each item. Then:
- Edit `homebrew/Brewfile` directly, preserving the category structure.
- Apply approved changes with `brew install` / `brew uninstall`, or run
  `make homebrew` to install everything in the file.
- Confirm with `brew bundle check --file=homebrew/Brewfile`.
- Commit at a logical checkpoint.
