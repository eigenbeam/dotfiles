;;; init --- Emacs init file
;;; Commentary:
;;; Code:

;; Temporarily increase size of GC threshold to speedup initialization.
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook
          #'(lambda ()
              (setq gc-cons-threshold (* 1024 1024))))

;; Bootstrap everything with package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	         '("melpa" . "https://melpa.org/packages/"))
(unless package--initialized (package-initialize))

;; Now use-package for all other packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(use-package org)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(org-babel-load-file "~/.emacs.d/basics.org")
(org-babel-load-file "~/.emacs.d/packages.org")
(org-babel-load-file "~/.emacs.d/dev.org")

;;; init.el ends here
