# Theme Experimentation Guide

Quick guide to switching between scientifically eye-friendly themes.

---

## Available Themes

All themes are installed and ready to use. Simply switch with `M-x load-theme`.

### Light Themes

| Theme | Characteristics | Best For |
|-------|----------------|----------|
| **modus-operandi** (default) | WCAG AAA, highest contrast, black text | Precision work, accessibility, reading |
| **solarized-light** | Warm, medium contrast, gentle | General coding, warm preference |
| **gruvbox-light-soft** | Retro, warm, gentle contrast | Long sessions, warm aesthetic |
| **gruvbox-light-hard** | Retro, warm, higher contrast | More definition needed |

### Dark Themes

| Theme | Characteristics | Best For |
|-------|----------------|----------|
| **modus-vivendi** | WCAG AAA, highest contrast, white text | Dark mode with accessibility |
| **solarized-dark** | Warm, medium contrast, most popular dark | General dark coding |
| **zenburn** | Warm, low contrast, gentle | Late night, long sessions, low light |
| **gruvbox-dark-soft** | Retro, warm, gentle contrast | Warm dark aesthetic |
| **gruvbox-dark-hard** | Retro, warm, higher contrast | More definition in dark |

---

## How to Switch Themes

### Quick Switch

```
M-x load-theme RET <theme-name> RET
```

Emacs will ask: "Disable theme modus-operandi? (y or n)"
- Type `y` to disable current theme first (recommended)

### Examples

**Try the dark variant:**
```
M-x load-theme RET modus-vivendi RET
```

**Try warm light theme:**
```
M-x load-theme RET solarized-light RET
```

**Try popular dark theme:**
```
M-x load-theme RET solarized-dark RET
```

**Try low-contrast dark:**
```
M-x load-theme RET zenburn RET
```

---

## Experimentation Tips

### Method 1: Quick Testing

Switch themes rapidly to compare:

```
M-x load-theme RET modus-operandi RET     (high contrast light)
M-x load-theme RET solarized-light RET    (warm light)
M-x load-theme RET gruvbox-light-soft RET (retro light)
```

**Tip:** Look at the same code file to compare readability.

### Method 2: Time-Based Testing

Use each theme for a full work session (2-4 hours):
- Day 1: `modus-operandi` (your default)
- Day 2: `solarized-light` (warm alternative)
- Day 3: `modus-vivendi` (dark variant)
- Day 4: `solarized-dark` (popular dark)
- Day 5: Choose your favorite

### Method 3: Lighting-Based

Match theme to your environment:
- **Bright office:** `modus-operandi` or `solarized-light`
- **Dim room:** `modus-vivendi` or `gruvbox-dark-soft`
- **Night coding:** `zenburn` or `solarized-dark`

---

## Making a Theme Permanent

Once you find your favorite, update `theme.el`:

### For Light Themes

**modus-operandi (default):**
```elisp
;; Already set - no change needed!
(load-theme 'modus-operandi t)
```

**solarized-light:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'solarized-light t)
```

**gruvbox-light-soft:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'gruvbox-light-soft t)
```

### For Dark Themes

**modus-vivendi:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'modus-vivendi t)
```

**solarized-dark:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'solarized-dark t)
```

**zenburn:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'zenburn t)
```

**gruvbox-dark-soft:**
```elisp
;; In theme.el, change line 36 to:
(load-theme 'gruvbox-dark-soft t)
```

---

## Theme Comparison Chart

### Contrast Levels

```
High Contrast (Best for precision):
├─ modus-operandi (light)
└─ modus-vivendi (dark)

Medium Contrast (Balanced):
├─ solarized-light
├─ solarized-dark
├─ gruvbox-light-hard
└─ gruvbox-dark-hard

Low Contrast (Gentle on eyes):
├─ gruvbox-light-soft
├─ gruvbox-dark-soft
└─ zenburn
```

### Color Temperature

```
Cool (Neutral):
└─ modus themes

Warm (Yellow/Orange tint):
├─ solarized themes
├─ gruvbox themes
└─ zenburn
```

### Scientific Backing

```
WCAG AAA (Accessibility Standard):
├─ modus-operandi ⭐⭐⭐⭐⭐
└─ modus-vivendi  ⭐⭐⭐⭐⭐

Color Theory Based:
├─ solarized-light ⭐⭐⭐⭐⭐
└─ solarized-dark  ⭐⭐⭐⭐⭐

Ergonomic Design:
├─ zenburn         ⭐⭐⭐⭐
├─ gruvbox themes  ⭐⭐⭐⭐
```

---

## What to Look For When Testing

### Readability
- Can you read code comfortably for 30+ minutes?
- Are comments easy to distinguish from code?
- Do strings/numbers stand out clearly?

### Eye Comfort
- Any eye strain after 1-2 hours?
- Colors feel harsh or gentle?
- Comfortable in your lighting conditions?

### Syntax Highlighting
- Can you quickly identify:
  - Functions vs variables
  - Keywords vs identifiers
  - Errors vs warnings
  - Comments vs code

### Personal Preference
- Does it "feel right"?
- Aesthetically pleasing?
- Makes you want to code?

---

## Common Preferences by Use Case

### For Accessibility / Color Blindness
**Use:** `modus-operandi` or `modus-vivendi`
- Only themes tested for all color blindness types
- WCAG AAA compliant

### For Long Coding Sessions (8+ hours)
**Light:** `solarized-light` or `gruvbox-light-soft`
**Dark:** `zenburn` or `gruvbox-dark-soft`
- Lower contrast = less eye fatigue

### For Precision Work (Reading dense code)
**Light:** `modus-operandi`
**Dark:** `modus-vivendi`
- Highest contrast = best precision

### For Aesthetic / "Vibe"
**Warm retro:** `gruvbox` variants
**Classic professional:** `solarized` variants
**Maximum clarity:** `modus` variants

### For Night Coding
**Try:** `zenburn`, `solarized-dark`, or `modus-vivendi`
- Zenburn = lowest blue light
- Solarized-dark = popular choice
- Modus-vivendi = if you need high contrast

---

## FAQ

### Q: Can I switch themes without restarting Emacs?
**A:** Yes! `M-x load-theme` works immediately.

### Q: Will my previous theme interfere?
**A:** Emacs asks to disable it. Always say `y` (yes) to avoid conflicts.

### Q: How do I see all available themes?
**A:** `M-x load-theme TAB` shows all installed themes.

### Q: Can I preview themes before loading?
**A:** Not built-in, but you can quickly load/unload to test.

### Q: What if I want to try themes not listed here?
**A:** You can install any Emacs theme. These are just the scientifically-backed ones.

### Q: Which theme is fastest/lightest?
**A:** All are equally fast. modus-themes is built-in (no download).

---

## Recommended Experimentation Order

Try in this order for best comparison:

1. **modus-operandi** (your current - high contrast light)
2. **solarized-light** (warm light - compare to #1)
3. **modus-vivendi** (high contrast dark)
4. **solarized-dark** (warm dark - most popular)
5. **zenburn** (low contrast dark - gentlest)
6. **gruvbox-light-soft** (retro light)
7. **gruvbox-dark-soft** (retro dark)

After trying all 7, you'll know:
- Light vs dark preference
- High vs low contrast preference
- Warm vs cool color preference
- Retro vs modern aesthetic preference

---

## Current Configuration

**Default theme:** `modus-operandi` (WCAG AAA light)
**Modeline:** `mood-line` (minimal, clean)

**To change default:** Edit `lisp/theme.el` line 36

---

*Experiment and find what works best for YOUR eyes and YOUR environment!*
