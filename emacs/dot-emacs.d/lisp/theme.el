;;; theme --- sets up the color theme
;;; Commentary:
;;; Code:

(setq nano-font-family-monospaced "RobotoMono Nerd Font")
(setq nano-font-size 14)

(require 'nano-layout)
(require 'nano-theme-light)
(require 'nano-faces)
(nano-faces)
(require 'nano-theme)
(nano-theme)
(require 'nano-defaults)
(require 'nano-session)
(require 'nano-modeline)
(require 'nano-bindings)
(require 'nano-splash)

;; nano-agenda
;; nano-base-colors
;; nano-colors
;; nano-command
;; nano-compact
;; nano-counsel
;; nano-help
;; nano-minibuffer
;; nano-mu4e
;; nano-splash
;; nano-writer

(let ((inhibit-message t))
  (message "Welcome to GNU Emacs / N Λ N O edition")
  (message (format "Initialization time: %s" (emacs-init-time))))

(require 'nano-splash)
(require 'nano-help)

(provide 'theme)

;;; theme.el ends here
