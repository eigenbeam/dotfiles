;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(if (display-graphic-p)
    (progn
      (set-frame-font "FiraCode Nerd Font 14")
      (set-frame-size (selected-frame) 100 50)))

(use-package nord-theme
  :init (load-theme 'nord t))

;; https://gitlab.com/jessieh/mood-line
(use-package mood-line
  :config
  (mood-line-mode)
  (setq mood-line-glyph-alist mood-line-glyphs-fira-code))


(provide 'theme)

;;; theme.el ends here
