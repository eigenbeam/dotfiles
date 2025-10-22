;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Font and Frame Settings
;; ----------------------------------------------------------

(if (display-graphic-p)
    (progn
      (set-frame-font "RobotoMono Nerd Font 14")
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
  :init
  ;; Load light theme by default
  (load-theme 'modus-operandi t))
  ;; Alternative: (load-theme 'modus-vivendi t)  ; Dark variant

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

;; Gruvbox - Retro, Warm, Balanced Contrast
;; https://github.com/greduan/emacs-theme-gruvbox
(use-package gruvbox-theme
  :defer t)
  ;; To use: M-x load-theme RET gruvbox-light-soft
  ;;     or: M-x load-theme RET gruvbox-dark-soft
  ;;     or: M-x load-theme RET gruvbox-light-hard
  ;;     or: M-x load-theme RET gruvbox-dark-hard


;; ----------------------------------------------------------
;; Theme Switching Quick Reference
;; ----------------------------------------------------------
;;
;; Switch themes with: M-x load-theme RET <theme-name>
;;
;; Available themes:
;;   modus-operandi       - Light, WCAG AAA, high contrast (default)
;;   modus-vivendi        - Dark, WCAG AAA, high contrast
;;   solarized-light      - Light, warm, medium contrast
;;   solarized-dark       - Dark, warm, medium contrast (popular)
;;   zenburn              - Dark, warm, low contrast (long sessions)
;;   gruvbox-light-soft   - Light, retro, warm, gentle
;;   gruvbox-light-hard   - Light, retro, warm, higher contrast
;;   gruvbox-dark-soft    - Dark, retro, warm, gentle
;;   gruvbox-dark-hard    - Dark, retro, warm, higher contrast
;;
;; Disable current theme first (if switching):
;;   M-x disable-theme RET <current-theme>
;;
;; Or use: M-x load-theme (it will ask to disable current theme)
;; ----------------------------------------------------------


(provide 'theme)

;;; theme.el ends here
