# Theme Guide

The default theme is **`gruvbox-dark-hard`** (set near the bottom of
`lisp/theme.el`) — dark, warm, moderate contrast. The modeline is `mood-line`
(minimal). If light text appears to smear (astigmatism halation), try
`gruvbox-dark-soft` or `-medium`, which use a lighter background.

A handful of alternative themes are installed for experimentation. Switch at
runtime with `M-x load-theme` (Emacs offers to disable the current theme first —
say yes to avoid face conflicts).

| Theme | Style |
|-------|-------|
| `gruvbox-dark-hard` *(default)* | Dark, warm, higher contrast |
| `gruvbox-dark-soft` / `-medium` | Dark, warm, gentler contrast / lighter bg |
| `gruvbox-light-soft` / `gruvbox-light-hard` | Light variants |
| `modus-vivendi` / `modus-operandi` | Dark / light, WCAG AAA, high contrast |
| `solarized-dark` / `solarized-light` | Warm, medium contrast |
| `zenburn` | Dark, warm, low contrast |

## Make a theme permanent

Edit the `load-theme` call in `lisp/theme.el`:

```elisp
(load-theme 'gruvbox-dark-hard t)
```
