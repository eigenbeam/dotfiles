;;; dev-lsp --- Dev modes setup -- lsp
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; LSP & DAP
;; ----------------------------------------------------------

(use-package lsp-mode
  :commands lsp
  :hook ((java-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq
   read-process-output-max (* 1024 1024)
   lsp-idle-delay 0.500
   lsp-pyls-plugins-pydocstyle-enabled t
   lsp-pyls-plugins-yapf-enabled t
   lsp-pyls-plugins-flake8-enabled t
   lsp-pyls-plugins-pycodestyle-enabled nil
   lsp-pyls-plugins-pyflakes-enabled nil))
(setq lsp-keymap-prefix "C-c l")

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq
   lsp-ui-sideline-enable t
   lsp-ui-sideline-show-diagnostics t
   lsp-ui-sideline-show-hover t
   lsp-ui-sideline-show-code-actions t
   ;; ----------------------------------------
   lsp-ui-peek-enable t
   lsp-ui-peek-list-width 60
   lsp-ui-peek-peek-height 25
   ;; ----------------------------------------
   lsp-ui-doc-enable t
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-position 'bottom
   ))

(use-package dap-mode
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (setq dap-python-debugger 'debugpy)
  (require 'dap-python))


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

;; https://github.com/galaunay/poetry.el
;; (use-package poetry)

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
