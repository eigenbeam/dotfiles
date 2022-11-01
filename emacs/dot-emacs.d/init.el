;;; init --- Emacs init file
;;; Commentary:
;;; Code:

;; Temporarily increase size of GC threshold to speedup initialization.
(setq gc-cons-threshold (* 256 1024 1024))

;; Bootstrap everything with package
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;; Now use-package for all other packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'basics)
(require 'packages)
(require 'dev)

;;; init.el ends here
