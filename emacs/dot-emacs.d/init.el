;;; init --- Emacs init file
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------------------
;; Increase size of GC threshold to speedup initialization
;; ----------------------------------------------------------------------
(setq gc-cons-threshold (* 256 1024 1024))
(add-hook 'after-init-hook
          #'(lambda ()
              (setq gc-cons-threshold (* 64 1024 1024))))

;; ----------------------------------------------------------------------
;; Setup package sources & initialize
;; ----------------------------------------------------------------------
(require 'package)

(setq package-archives
      (append package-archives
              '(("melpa" . "https://melpa.org/packages/")
                ("org" . "https://orgmode.org/elpa/"))))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; ----------------------------------------------------------------------
;; Auto-recover from a stale archive cache
;; ----------------------------------------------------------------------
;; `package-archive-contents' is only refreshed above when it is empty, so a
;; cache that has aged since the first launch keeps pointing at MELPA nightly
;; builds that have since been rotated off the server.  Any package added
;; later then fails to install with a 404.  Refresh the index once and retry
;; on the first such failure; re-signal anything that still fails afterward so
;; genuine errors are not masked.
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
;; Install use-package
;; ----------------------------------------------------------------------
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(setq use-package-compute-statistics t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ----------------------------------------------------------------------
;; Load user configuration
;; ----------------------------------------------------------------------
(require 'basics)
(require 'theme)
(require 'packages)
(require 'dev)
(require 'org-config)

;;; init.el ends here
