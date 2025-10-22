;;; basics --- basic configuration
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Sane defaults
;; ----------------------------------------------------------

; Minimalistic UI settings
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 20)
(setq ring-bell-function 'ignore)
(blink-cursor-mode 1)
(setq blink-cursor-blinks 0)
(column-number-mode t)
(global-display-line-numbers-mode)
(dolist (mode '(org-mode-hook vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

; ESC will quit like C-g
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

; Nicer scrolling behavior
(setq scroll-margin 0)
(setq scroll-conservatively 1000)
(setq scroll-preserve-screen-position +1)

(setq select-enable-clipboard t)

(setq uniquify-buffer-name-style 'forward)
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode t)

(setq custom-file (locate-user-emacs-file ".custom.el"))
(load custom-file t t)

; Mac-specific settings
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq mac-right-option-modifier 'control)
(setq dired-use-ls-dired nil)


;; ----------------------------------------------------------
;; Vertico - Modern completion UI
;; ----------------------------------------------------------
;; https://github.com/minad/vertico
(use-package vertico
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; https://github.com/oantolin/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; https://github.com/minad/marginalia
(use-package marginalia
  :init
  (marginalia-mode))

;; https://github.com/minad/consult
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-s g" . consult-grep)
         ("M-s r" . consult-ripgrep)))

;; Keep ibuffer for buffer management
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; ----------------------------------------------------------
;; Tidy up text
;; ----------------------------------------------------------

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'prog-mode-hook
	  (lambda ()
	    (set (make-local-variable 'comment-auto-fill-only-comments) t)
	    (auto-fill-mode t)
	    (add-hook 'before-save-hook 'delete-trailing-whitespace)))


;; ----------------------------------------------------------
;; Tidy up files
;; ----------------------------------------------------------

(use-package no-littering)

(setq create-lockfiles nil)

;; Enable backups with version control in no-littering directory
(setq make-backup-files t)
(setq backup-by-copying t)
(setq version-control t)
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq backup-directory-alist
      `(("." . ,(no-littering-expand-var-file-name "backup/"))))

;; Enable auto-save in no-littering directory
(setq auto-save-default t)
(setq auto-save-file-name-transforms
	  `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))


;; ----------------------------------------------------------
;; Misc initialization
;; ----------------------------------------------------------

(random t)

(require 'server)
(if (not (server-running-p))
    (server-start))


(provide 'basics)

;;; basics.el ends here
