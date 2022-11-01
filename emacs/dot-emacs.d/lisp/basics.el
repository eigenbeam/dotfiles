;;; basics --- basic configuration
;;; Commentary:
;;; Code:

;; BUGFIX: Native compilation on MacOS throws warnings in 28.2
;;         This will be fixed in 28.3+
(when (eq system-type 'darwin) (customize-set-variable 'native-comp-driver-options '("-Wl,-w")))

(require 'server)
(if (not (server-running-p))
    (server-start))

(setq inhibit-startup-message t)

(blink-cursor-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq blink-cursor-blinks 0)
(column-number-mode t)
(global-display-line-numbers-mode)
(global-hl-line-mode +1)
(size-indication-mode +1)

(setq scroll-margin 0)
(setq scroll-conservatively 1000)
(setq scroll-preserve-screen-position +1)

(if (display-graphic-p)
    (progn
      (set-frame-font "RobotoMono Nerd Font 14")
      (set-frame-size (selected-frame) 100 50)))

(setq select-enable-clipboard t)

;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)

(random t)


(setq uniquify-buffer-name-style 'forward)
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode t)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq custom-file (locate-user-emacs-file ".custom.el"))
(load custom-file t t)

;; Use ido mode
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode t)

;; keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)
(windmove-default-keybindings)

(add-hook 'prog-mode-hook
	  (lambda ()
	    (set (make-local-variable 'comment-auto-fill-only-comments) t)
	    (auto-fill-mode t)
	    (add-hook 'before-save-hook 'delete-trailing-whitespace)))

(use-package no-littering
  :ensure t)
(use-package diminish
  :ensure t)

(provide 'basics)

;;; basics.el ends here
