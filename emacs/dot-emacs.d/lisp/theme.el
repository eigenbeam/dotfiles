;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(if (display-graphic-p)
    (progn
      (set-frame-font "RobotoMono Nerd Font 14")
      (set-frame-size (selected-frame) 100 50)))

(use-package nord-theme
  :init (load-theme 'nord t))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(provide 'theme)

;;; theme.el ends here
