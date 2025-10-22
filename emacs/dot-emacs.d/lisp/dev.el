;;; dev --- development modes setup
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Eglot - Built-in LSP Client
;; ----------------------------------------------------------

(use-package eglot
  :ensure nil  ; Built-in to Emacs 29+
  :hook
  ((python-mode . eglot-ensure)
   (js-mode . eglot-ensure)
   (java-mode . eglot-ensure)
   (c-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   (sh-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)  ; Shutdown server when last buffer is closed
  (eglot-events-buffer-size 0)  ; Disable event logging (improves performance)
  (eglot-sync-connect nil)  ; Async connection
  :bind (:map eglot-mode-map
         ("C-c l r" . eglot-rename)
         ("C-c l a" . eglot-code-actions)
         ("C-c l f" . eglot-format)
         ("C-c l d" . eldoc)
         ("C-c l h" . eldoc-doc-buffer))
  :config
  ;; Increase process output for better performance
  (setq read-process-output-max (* 1024 1024)))


;; ----------------------------------------------------------
;; DAP - Debug Adapter Protocol
;; ----------------------------------------------------------

(use-package dap-mode
  :bind (;; General debugging
         ("C-c d d" . dap-debug)
         ("C-c d l" . dap-debug-last)
         ("C-c d r" . dap-debug-recent)
         ;; Breakpoints
         ("C-c d b" . dap-breakpoint-toggle)
         ("C-c d B" . dap-breakpoint-delete-all)
         ;; Stepping
         ("C-c d n" . dap-next)
         ("C-c d i" . dap-step-in)
         ("C-c d o" . dap-step-out)
         ("C-c d c" . dap-continue)
         ;; UI panels
         ("C-c d u l" . dap-ui-locals)
         ("C-c d u s" . dap-ui-sessions)
         ("C-c d u b" . dap-ui-breakpoints)
         ("C-c d u r" . dap-ui-repl)
         ;; Java test running
         ("C-c d t m" . dap-java-run-test-method)
         ("C-c d t c" . dap-java-run-test-class))
  :custom
  (dap-auto-configure-features '(sessions locals breakpoints expressions controls tooltip))
  :config
  ;; Enable UI features
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)

  ;; Python debugging with debugpy
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)

  ;; Java debugging
  (require 'dap-java)

  ;; Node.js debugging (JavaScript/TypeScript)
  (require 'dap-node)
  (dap-node-setup)

  ;; C/C++ debugging (LLDB for macOS)
  (require 'dap-lldb))


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

;; JSP support
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode)))


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


;; ----------------------------------------------------------
;; Miscellaneous
;; ----------------------------------------------------------

;; Fix escape codes so they show up as color
(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

(defun kwb-dev-mode-hook ()
  (subword-mode))
(add-hook 'prog-mode-hook 'kwb-dev-mode-hook)


(provide 'dev)

;;; dev.el ends here
