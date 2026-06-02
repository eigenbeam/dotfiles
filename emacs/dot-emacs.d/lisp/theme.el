;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Font and Frame Settings
;; ----------------------------------------------------------

(if (display-graphic-p)
    (progn
      (set-frame-font "JetBrains Mono Nerd Font 14")
      (set-frame-size (selected-frame) 120 60)))

(use-package nerd-icons)


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
  ;; Load dark-soft variant by default (low-contrast, no pure-black bg)
  (load-theme 'gruvbox-dark-soft t))
  ;; Alternative variants:
  ;;   M-x load-theme RET gruvbox-light-soft
  ;;   M-x load-theme RET gruvbox-light-hard
  ;;   M-x load-theme RET gruvbox-dark-hard


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
