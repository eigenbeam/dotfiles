;;; theme.el --- Font, mode line, and color theme  -*- lexical-binding: t -*-
;;; Commentary:
;; Gruvbox dark throughout, matching ghostty/tmux/nvim.  The built-in modus
;; themes remain available via `M-x load-theme' for a high-contrast day.
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
;; https://github.com/greduan/emacs-theme-gruvbox
;; dark-hard: warm, a bit more contrast than soft for legibility.  The
;; background is near-black; if text seems to smear (astigmatism halation),
;; fall back to gruvbox-dark-soft or -medium.  Built-in alternatives:
;; modus-vivendi / modus-operandi (WCAG AAA).
(use-package gruvbox-theme
  :init
  (load-theme 'gruvbox-dark-hard t))


(provide 'theme)

;;; theme.el ends here
