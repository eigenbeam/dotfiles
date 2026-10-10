;;; basics.el --- Core settings, files, and the minibuffer stack  -*- lexical-binding: t -*-
;;; Commentary:
;; Loaded first.  no-littering must precede every mode that persists state
;; (savehist, recentf, save-place, custom), so it leads the file.
;;; Code:

;; ----------------------------------------------------------
;; Keep ~/.emacs.d clean
;; ----------------------------------------------------------
;; https://github.com/emacscollective/no-littering
;; Runtime state goes to var/, generated config to etc/ (both gitignored).
(use-package no-littering
  :demand t
  :config
  ;; Backups and auto-saves under var/ instead of next to the file.
  (no-littering-theme-backups)
  ;; Customize output stays out of git; themes load with NO-CONFIRM so no
  ;; `custom-safe-themes' list is needed.
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (load custom-file t t))

(setq create-lockfiles nil)
(setq make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)


;; ----------------------------------------------------------
;; Sane defaults
;; ----------------------------------------------------------

;; Warnings stay visible (a hidden *Warnings* buffer hides package-install
;; failures); only the noisy *Compile-Log* is suppressed below.
(setq warning-minimum-level :warning)
(setq byte-compile-warnings '(not obsolete))

;; Menu/tool/scroll bars are disabled in early-init.el via `default-frame-alist'.
(tooltip-mode -1)
(set-fringe-mode 20)
(setq ring-bell-function 'ignore)
(blink-cursor-mode 1)
(setq blink-cursor-blinks 0)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(dolist (hook '(org-mode-hook vterm-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

;; ESC quits like C-g.
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;; Scrolling
(setq scroll-margin 0
      scroll-conservatively 1000
      scroll-preserve-screen-position t)
(pixel-scroll-precision-mode 1)   ; smooth trackpad scrolling

(setq uniquify-buffer-name-style 'forward)
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

(setq-default indent-tabs-mode nil
              tab-width 4)
(setq tab-always-indent 'complete)   ; TAB indents, then completes (corfu)
(setq use-short-answers t)           ; y/n instead of yes/no
(setq isearch-lazy-count t)          ; "3/17" while searching
(setq xref-search-program 'ripgrep)
;; No aspell is installed; keep ispell out of completion-at-point in text modes.
(setq text-mode-ispell-word-completion nil)

;; Files edited outside Emacs (Claude Code, git, formatters) reload on their own.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t   ; dired too
      auto-revert-check-vc-info t)            ; branch in the mode line stays current

;; Remember minibuffer history, recent files, and cursor positions.  These make
;; vertico/consult smarter (history-based sorting, recentf in consult-buffer)
;; and reopen files where you left off.
(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(save-place-mode 1)

;; Built-in structural editing
(electric-pair-mode 1)
(show-paren-mode 1)

;; The repo .editorconfig governs indentation (built in since Emacs 30).
(editorconfig-mode 1)

;; Repeatable commands: C-x o o o, C-x { { {, dape stepping.
(repeat-mode 1)

;; A little extra line spacing aids readability and line-tracking (low vision /
;; astigmatism / ADHD).
(setq-default line-spacing 0.25)

;; ediff in one frame, side by side.  claude-code-ide reviews edits in ediff.
(setq ediff-window-setup-function #'ediff-setup-windows-plain
      ediff-split-window-function #'split-window-horizontally)

;; Mac-specific settings.  emacs-plus is an NS build, so these are ns-*-modifier
;; (the mac-*-modifier names belong to the emacs-mac port and are inert here).
(setq ns-command-modifier 'meta
      ns-option-modifier nil
      ns-right-option-modifier 'control)
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
(global-set-key (kbd "C-x C-b") #'ibuffer)


;; ----------------------------------------------------------
;; Tidy up text
;; ----------------------------------------------------------

(add-hook 'text-mode-hook #'turn-on-auto-fill)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local comment-auto-fill-only-comments t)
            (auto-fill-mode 1)
            ;; Buffer-local so trailing whitespace is stripped only in prog
            ;; buffers, not in Markdown (trailing-space hard breaks) or Org.
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))


;; ----------------------------------------------------------
;; Misc initialization
;; ----------------------------------------------------------

(require 'server)
(unless (server-running-p)
  (server-start))

;; Hide the byte-compile log; warnings themselves still surface.
(add-to-list 'display-buffer-alist
             '("\\*Compile-Log\\*"
               (display-buffer-no-window)
               (allow-no-window . t)))


(provide 'basics)

;;; basics.el ends here
