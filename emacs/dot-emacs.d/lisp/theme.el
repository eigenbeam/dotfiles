;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(setq nano-font-family-monospaced "RobotoMono Nerd Font")
(setq nano-font-size 12)

(require 'nano-layout)
(require 'nano-theme-dark)
(require 'nano-faces)
(nano-faces)
(require 'nano-theme)
(nano-theme)
(require 'nano-defaults)
(require 'nano-session)
(require 'nano-modeline)
(require 'nano-bindings)

(let ((inhibit-message t))
  (message "Welcome to GNU Emacs / N Λ N O edition")
  (message (format "Initialization time: %s" (emacs-init-time))))

(require 'nano-splash)
(require 'nano-help)

(provide 'theme)

;;; theme.el ends here
