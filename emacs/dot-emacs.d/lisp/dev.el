;;; dev --- development modes setup
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; LSP
;; ----------------------------------------------------------

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((java-mode . lsp)
   (js-mode . lsp)
   (typescript-ts-mode . lsp)
   (python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)


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
  :config
  (add-hook 'js-mode-hook 'add-node-modules-path))

(use-package typescript-ts-mode)

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


;; ----------------------------------------------------------
;; Miscellaneous
;; ----------------------------------------------------------

;; Fix escape codes so they show up as color
(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

(defun kwb-dev-mode-hook ()
  (subword-mode))
(add-hook 'dev-mode-hook 'kwb-dev-mode-hook)


(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (java "https://github.com/tree-sitter/tree-sitter-java")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))


(provide 'dev)

;;; dev-lsp.el ends here
