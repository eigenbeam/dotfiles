;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(if (display-graphic-p)
    (progn
      (set-frame-font "RobotoMono Nerd Font 14")
      (set-frame-size (selected-frame) 120 60)))

(use-package nerd-icons)

(use-package modus-themes
  :init (load-theme 'modus-operandi t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


(provide 'theme)

;;; theme.el ends here
