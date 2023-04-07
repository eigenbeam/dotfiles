;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; LSP
;; ----------------------------------------------------------

(use-package lsp-mode
  :hook
  ((lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui)


;; ----------------------------------------------------------
;; DAP
;; ----------------------------------------------------------

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-java)
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

;; JSP
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode)))

(use-package lsp-java
  :config (add-hook 'java-mode-hook 'lsp))

(use-package dap-java
  :ensure nil)


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
