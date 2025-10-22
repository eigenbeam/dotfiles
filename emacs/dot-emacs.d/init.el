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
