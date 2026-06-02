;;; basics --- basic configuration
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Sane defaults
;; ----------------------------------------------------------

;; Suppress annoying compilation buffers
(setq native-comp-async-report-warnings-errors nil)  ; Native comp warnings
(setq byte-compile-warnings '(not obsolete))          ; Reduce byte-compile warnings
(setq warning-minimum-level :error)                   ; Only show errors, not warnings

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
(pixel-scroll-precision-mode 1)  ; smooth trackpad scrolling (Emacs 29+)

(setq select-enable-clipboard t)

(setq uniquify-buffer-name-style 'forward)
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode t)

;; Remember minibuffer history, recent files, and cursor positions.  These make
;; vertico/consult smarter (history-based sorting, recentf in consult-buffer)
;; and reopen files where you left off.
(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(save-place-mode 1)

;; Built-in structural editing (replaces smartparens)
(electric-pair-mode 1)
(show-paren-mode 1)

(setq custom-file (locate-user-emacs-file ".custom.el"))
(load custom-file t t)

;; Mac-specific settings.  emacs-plus is an NS build, so these are ns-*-modifier
;; (the mac-*-modifier names belong to the emacs-mac port and are inert here).
(setq ns-command-modifier 'meta)
(setq ns-option-modifier nil)
(setq ns-right-option-modifier 'control)
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
  ;; Let eglot completion use orderless too (it otherwise forces its own style).
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot (styles orderless))
                                   (eglot-capf (styles orderless)))))

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
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-g f" . consult-flymake)))

;; Keep ibuffer for buffer management
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; ----------------------------------------------------------
;; Tidy up text
;; ----------------------------------------------------------

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local comment-auto-fill-only-comments t)
            (auto-fill-mode t)
            ;; buffer-local (nil t) so we only strip trailing whitespace in prog
            ;; buffers — not globally, which would clobber e.g. Markdown's
            ;; trailing-space hard line breaks.
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))


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

(require 'server)
(if (not (server-running-p))
    (server-start))

;; Hide compilation buffers automatically
(add-to-list 'display-buffer-alist
             '("\\*Compile-Log\\*"
               (display-buffer-no-window)
               (allow-no-window . t)))

(add-to-list 'display-buffer-alist
             '("\\*Warnings\\*"
               (display-buffer-no-window)
               (allow-no-window . t)))


(provide 'basics)

;;; basics.el ends here
