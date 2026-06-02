;;; theme --- sets up the color theme
;;; Commentary:
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
;; codepoint ranges to Symbols Nerd Font Mono for any literal glyphs in buffers.
(when (and (display-graphic-p)
           (find-font (font-spec :name "Symbols Nerd Font Mono")))
  (dolist (range '((#xe000 . #xf8ff)      ; BMP Private Use Area (most Nerd glyphs)
                   (#xf0000 . #xfffff)))   ; supplementary PUA-A (Material Design, etc.)
    (set-fontset-font t range (font-spec :family "Symbols Nerd Font Mono") nil 'prepend)))

(use-package nerd-icons
  :custom
  ;; Atkinson Hyperlegible Mono has no icon glyphs; render nerd-icons with the
  ;; dedicated symbols font instead.
  (nerd-icons-font-family "Symbols Nerd Font Mono"))


;; ----------------------------------------------------------
;; Modeline - Simple and Clean
;; ----------------------------------------------------------

;; https://gitlab.com/jessieh/mood-line
(use-package mood-line
  :config
  (mood-line-mode))


;; ----------------------------------------------------------
;; Color Themes - Scientifically Eye-Friendly
;; ----------------------------------------------------------

;; Modus Themes - WCAG AAA Compliant (Highest Accessibility)
;; https://protesilaos.com/emacs/modus-themes
(use-package modus-themes
  :defer t)
  ;; To use: M-x load-theme RET modus-operandi
  ;;     or: M-x load-theme RET modus-vivendi

;; Solarized - Color Theory Based, Perceptually Uniform
;; https://github.com/bbatsov/solarized-emacs
(use-package solarized-theme
  :defer t)
  ;; To use: M-x load-theme RET solarized-light
  ;;     or: M-x load-theme RET solarized-dark

;; Zenburn - Low Contrast, Warm Colors, Long-Session Optimized
;; https://github.com/bbatsov/zenburn-emacs
(use-package zenburn-theme
  :defer t)
  ;; To use: M-x load-theme RET zenburn

;; Gruvbox - Retro, Warm, Balanced Contrast (default)
;; https://github.com/greduan/emacs-theme-gruvbox
(use-package gruvbox-theme
  :init
  ;; dark-hard: warm, a bit more contrast than soft for legibility.  The
  ;; background is darker (near-black); if text seems to smear (astigmatism
  ;; halation), fall back to gruvbox-dark-soft or -medium.
  (load-theme 'gruvbox-dark-hard t))
  ;; Alternative variants:
  ;;   M-x load-theme RET gruvbox-dark-soft
  ;;   M-x load-theme RET gruvbox-dark-medium
  ;;   M-x load-theme RET gruvbox-light-soft


;; ----------------------------------------------------------
;; Theme Switching Quick Reference
;; ----------------------------------------------------------
;;
;; Switch themes with: M-x load-theme RET <theme-name>
;;
;; Available themes:
;;   gruvbox-dark-soft    - Dark, retro, warm, gentle (default)
;;   gruvbox-dark-hard    - Dark, retro, warm, higher contrast
;;   gruvbox-light-soft   - Light, retro, warm, gentle
;;   gruvbox-light-hard   - Light, retro, warm, higher contrast
;;   modus-operandi       - Light, WCAG AAA, high contrast
;;   modus-vivendi        - Dark, WCAG AAA, high contrast
;;   solarized-light      - Light, warm, medium contrast
;;   solarized-dark       - Dark, warm, medium contrast (popular)
;;   zenburn              - Dark, warm, low contrast (long sessions)
;;
;; Disable current theme first (if switching):
;;   M-x disable-theme RET <current-theme>
;;
;; Or use: M-x load-theme (it will ask to disable current theme)
;; ----------------------------------------------------------


(provide 'theme)

;;; theme.el ends here
