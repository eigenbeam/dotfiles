;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(if (display-graphic-p)
    (progn
      (set-frame-font "RobotoMono Nerd Font 14")
      (set-frame-size (selected-frame) 100 50)))

;; https://protesilaos.com/emacs/modus-themes
(use-package modus-themes
  :init
  (setq modus-themes-common-palette-overrides
      '((border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified)))

  (setq modus-themes-italic-constructs nil
        modus-themes-bold-constructs nil)
  :config
  (load-theme 'modus-operandi)
  :bind
  ("<f5>" . modus-themes-toggle))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(provide 'theme)

;;; theme.el ends here
