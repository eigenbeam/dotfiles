;;; theme.el --- Font, mode line, and color theme  -*- lexical-binding: t -*-
;;; Commentary:
;; Zenwritten Light throughout: ghostty sets the terminal palette, nvim uses
;; zenwritten, and Emacs pins the built-in modus-operandi-tinted to the same
;; values (no Emacs port of zenbones exists).
;;; Code:

;; ----------------------------------------------------------
;; Font — auto-sized per display
;; ----------------------------------------------------------
;; This config is stow-shared across a 15" Air, a 14" MBP, and an external
;; 27" 4K, so the point size is chosen from each frame's *current* monitor
;; rather than hardcoded.  It re-applies on new frames and when a frame is
;; dragged to another monitor (dock/undock), and degrades to the default face
;; if the font isn't installed (set-frame-font errors on a missing font).

(defvar kwb/font-family "Atkinson Hyperlegible Mono"
  "Monospace family used for graphical frames (matches ghostty).")

(defvar kwb/font-weight 'medium
  "Weight for `kwb/font-family'; heavier strokes resist astigmatism halation.")

(defun kwb/font-size-for-frame (&optional frame)
  "Choose a `kwb/font-family' point size from FRAME's monitor geometry.
Uses physical width (mm) as a laptop-vs-desktop / viewing-distance proxy and
logical pixel width to tell a 4K \"more space\" mode from plain 2x."
  (let* ((attrs (frame-monitor-attributes frame))
         (geom  (alist-get 'geometry attrs))
         (mm    (alist-get 'mm-size attrs))
         (px-w  (and geom (nth 2 geom)))    ; logical (HiDPI) pixel width
         (mm-w  (and mm (car mm))))         ; physical width, millimetres
    (cond
     ((or (null mm-w) (zerop mm-w)) 18)                    ; unknown → safe default
     ((>= mm-w 450) (if (and px-w (>= px-w 2400)) 20 18))  ; external desktop monitor
     (t 18))))                                             ; laptop panels (15"/14")

(defun kwb/apply-font (&optional frame)
  "Set `kwb/font-family' at `kwb/font-weight' on FRAME, sized for its monitor.
A no-op (leaving the default face) when the font is unavailable."
  (when (and (display-graphic-p frame)
             (find-font (font-spec :name kwb/font-family)))
    (let ((size (kwb/font-size-for-frame frame)))
      ;; Only retouch the frame when the target size changes, so dragging
      ;; between monitors doesn't thrash on every move event.
      (unless (equal size (frame-parameter frame 'kwb-font-size))
        (set-frame-parameter frame 'kwb-font-size size)
        (set-face-attribute 'default (or frame (selected-frame))
                            :family kwb/font-family
                            :height (* size 10)
                            :weight kwb/font-weight)))))

;; A sensible baseline for frames created before the hook fires (daemon
;; clients), refined by `kwb/apply-font'.
(when (find-font (font-spec :name kwb/font-family))
  (add-to-list 'default-frame-alist
               (cons 'font (format "%s 18" kwb/font-family))))

(add-hook 'after-make-frame-functions #'kwb/apply-font)
(add-hook 'move-frame-functions #'kwb/apply-font)

(when (display-graphic-p)
  (kwb/apply-font)
  (set-frame-size (selected-frame) 120 60))

;; Atkinson Hyperlegible Mono carries no Nerd-Font glyphs, so map the icon
;; codepoint ranges to Symbols Nerd Font Mono for literal glyphs in buffers
;; (starship/tmux configs, Claude's TUI output in vterm, ...).
(when (and (display-graphic-p)
           (find-font (font-spec :name "Symbols Nerd Font Mono")))
  (dolist (range '((#xe000 . #xf8ff)      ; BMP Private Use Area (most Nerd glyphs)
                   (#xf0000 . #xfffff)))   ; supplementary PUA-A (Material Design, etc.)
    (set-fontset-font t range (font-spec :family "Symbols Nerd Font Mono") nil 'prepend)))


;; ----------------------------------------------------------
;; Mode line - simple and clean (hides minor modes, so no diminish needed)
;; ----------------------------------------------------------
;; https://gitlab.com/jessieh/mood-line
(use-package mood-line
  :config
  (mood-line-mode))


;; ----------------------------------------------------------
;; Color theme
;; ----------------------------------------------------------
;; Built-in modus-operandi-tinted (Emacs 31 ships modus-themes 4.x), loaded
;; with `require-theme' (it lives in etc/themes, not ELPA).  "faint" preset
;; for low noise, then neutrals, accents and syntax slots pinned to
;; Zenwritten Light (ghostty theme + nvim colors/zenwritten.vim) so Emacs
;; matches ghostty/nvim.  Theme-specific overrides beat the common (faint)
;; ones.  Dark later: same shape in `modus-vivendi-tinted-palette-overrides',
;; then `modus-themes-toggle'.
(require-theme 'modus-themes)

(setq modus-themes-italic-constructs t   ; comments/docstrings italic, as zenwritten
      modus-themes-bold-constructs t     ; keywords bold, as zenwritten's Statement
      modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted)
      modus-themes-common-palette-overrides modus-themes-preset-overrides-faint)

(setq modus-operandi-tinted-palette-overrides
      '(;; neutrals
        (bg-main "#eeeeee") (fg-main "#353535")
        (bg-dim "#e5e5e5") (fg-dim "#5c5c5c") (fg-alt "#636363")
        (bg-active "#d7d7d7") (bg-inactive "#dddddd")
        (bg-region "#d7d7d7") (fg-region unspecified)
        (bg-hl-line "#e5e5e5")
        (border "#989898")
        (cursor "#353535")                      ; tinted default is red
        (bg-mode-line-active "#cfcfcf") (fg-mode-line-active "#353535")
        (border-mode-line-active "#cfcfcf")
        (bg-mode-line-inactive "#dddddd") (fg-mode-line-inactive "#686868")
        (border-mode-line-inactive "#dddddd")
        (fg-line-number-inactive "#989898") (fg-line-number-active "#353535")
        ;; accents = terminal ANSI 1-6
        (red "#a8334c") (green "#4f6c31") (yellow "#944927")
        (blue "#286486") (magenta "#88507d") (cyan "#3b8992")
        ;; zenwritten's near-monochrome syntax
        (comment "#8b8b8b") (docstring "#636363")
        (string "#636363") (constant "#636363")
        (keyword fg-main) (builtin fg-main) (fnname fg-main)
        (variable "#505050") (type "#735057") (preprocessor "#5c5c5c")
        ;; diffs and paren match
        (bg-added "#cbe5b8") (bg-removed "#ebd8da") (bg-changed "#d4dee7")
        (bg-paren-match "#deb9d6")))

(modus-themes-load-theme 'modus-operandi-tinted)


(provide 'theme)

;;; theme.el ends here
