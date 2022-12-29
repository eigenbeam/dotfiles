;;; basics --- basic configuration
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Temporary
;; ----------------------------------------------------------

;; BUGFIX: Native compilation on MacOS throws warnings in 28.2
;;         This will be fixed in 28.3+
(when (eq system-type 'darwin) (customize-set-variable 'native-comp-driver-options '("-Wl,-w")))
(setq native-comp-async-report-warnings-errors 'silent)

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
;; IDO mode
;; ----------------------------------------------------------
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode t)
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

(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(use-package no-littering)
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
