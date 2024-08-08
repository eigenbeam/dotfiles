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
   (python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq read-process-output-max (* 1024 1024))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)


;; ----------------------------------------------------------
;; DAP
;; ----------------------------------------------------------

(use-package dap-mode
  :after lsp-mode
  ;; keybindings are Java-specific for now
  :bind (("C-c d t m" . dap-java-run-test-method)
         ("C-c d t c" . dap-java-run-test-class)
         ("C-c d t l" . dap-java-run-last-test))
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

;; https://github.com/jorgenschaefer/pyvenv
(use-package pyvenv
  :config
  (pyvenv-mode 1))

(use-package poetry
  :ensure t
  :config
  (setq poetry-tracking-strategy 'projectile))

;; Built-in python mode
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i")

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


(provide 'dev)

;;; dev-lsp.el ends here
