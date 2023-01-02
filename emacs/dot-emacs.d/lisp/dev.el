;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; LSP
;; ----------------------------------------------------------

(use-package eglot
  :hook ((c++-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (fortran-mode . eglot-ensure)
         (f90-mode . eglot-ensure)
         (python-mode . eglot-ensure)))


;; ----------------------------------------------------------
;; DAP
;; ----------------------------------------------------------

(use-package dap-mode
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (setq dap-python-debugger 'debugpy)
  (require 'dap-python))


;; ----------------------------------------------------------
;; C & C++
;; ----------------------------------------------------------

;; ----------------------------------------------------------
;; JavaScript & TypeScript
;; ----------------------------------------------------------

;; https://github.com/codesuki/add-node-modules-path
(use-package add-node-modules-path
  :pin melpa-stable
  :hook (js-mode typescript-mode))

;; https://github.com/emacs-typescript/typescript.el
(use-package typescript-mode)


;; ----------------------------------------------------------
;; Java
;; ----------------------------------------------------------

(use-package lsp-java)


;; ----------------------------------------------------------
;; Julia
;; ----------------------------------------------------------

;; https://github.com/JuliaEditorSupport/julia-emacs
(use-package julia-mode)


;; ----------------------------------------------------------
;; Python
;; ----------------------------------------------------------

;; Built-in python mode
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i")

;; https://github.com/jorgenschaefer/pyvenv
(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; https://github.com/wbolster/emacs-python-pytest
;; (use-package python-pytest
;;   :commands (python-pytest-dispatch)
;;   :bind ("C-c u" . python-pytest-dispatch))

;; https://github.com/nnicandro/emacs-jupyter
;; (use-package jupyter)



(provide 'dev)

;;; dev-lsp.el ends here
