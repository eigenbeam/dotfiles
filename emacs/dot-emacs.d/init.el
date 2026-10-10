;;; init.el --- Entry point  -*- lexical-binding: t -*-
;;; Commentary:
;; Package setup, then the modules under lisp/ in dependency order.  Startup
;; tuning (GC, frame defaults, eln cache) lives in early-init.el.
;;; Code:

;; ----------------------------------------------------------------------
;; Package sources
;; ----------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Auto-recover from a stale archive cache.  `package-archive-contents' is only
;; refreshed above when it is empty, so a cache that has aged since the first
;; launch keeps pointing at MELPA nightly builds that have since been rotated
;; off the server, and any package added later fails to install with a 404.
;; Refresh the index once and retry on the first such failure; re-signal
;; anything that still fails afterward so genuine errors are not masked.
(defvar my/package-archives-refreshed nil
  "Non-nil once the archives have been refreshed mid-session to recover an install.")

(defun my/package-install-refresh-retry (orig-fn &rest args)
  "Around-advice for `package-install': refresh archives once and retry on failure."
  (condition-case err
      (apply orig-fn args)
    (error
     (if my/package-archives-refreshed
         (signal (car err) (cdr err))
       (setq my/package-archives-refreshed t)
       (message "Package install failed (%s); refreshing archives and retrying..."
                (error-message-string err))
       (package-refresh-contents)
       (apply orig-fn args)))))

(advice-add 'package-install :around #'my/package-install-refresh-retry)

;; ----------------------------------------------------------------------
;; use-package (built in since Emacs 29)
;; ----------------------------------------------------------------------
(require 'use-package)
(setq use-package-always-ensure t)

;; ----------------------------------------------------------------------
;; Modules
;; ----------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'basics)      ; no-littering, defaults, minibuffer stack
(require 'theme)       ; font, mode line, color theme
(require 'packages)    ; general-purpose packages, Claude Code
(require 'dev)         ; eglot, apheleia, dape, languages
(require 'org-config)  ; org-mode

;;; init.el ends here
