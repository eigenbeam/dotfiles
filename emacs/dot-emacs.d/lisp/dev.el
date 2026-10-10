;;; dev.el --- Language servers, formatting, debugging, languages  -*- lexical-binding: t -*-
;;; Commentary:
;; Built-in eglot for LSP, apheleia for format-on-save (mirrors nvim's
;; conform table), flymake-ruff for Python lint parity, envrc for per-project
;; environments, dape for DAP debugging, and Julia.  Mathematica is not
;; configured (notebooks live in the Wolfram front end).
;;; Code:

;; ----------------------------------------------------------
;; Eglot - built-in LSP client
;; ----------------------------------------------------------
;; Servers come from eglot's defaults: clangd (Xcode CLT), pyright (brew),
;; jdtls (brew), typescript-language-server (make tools),
;; bash-language-server (brew), and LanguageServer.jl via eglot-jl below.
(use-package eglot
  :ensure nil
  ;; Hook BOTH the classic and tree-sitter major modes.  `treesit-enabled-modes'
  ;; remaps files to *-ts-mode, and the ts variants do NOT run the classic
  ;; mode's hook (they only declare it as an extra parent), so hooking only
  ;; python-mode/js-mode/... silently fails to start eglot there.
  :hook
  (((python-mode python-ts-mode
     js-mode js-ts-mode typescript-ts-mode tsx-ts-mode
     java-mode java-ts-mode
     c-mode c-ts-mode c++-mode c++-ts-mode
     sh-mode bash-ts-mode
     julia-mode) . eglot-ensure))
  :custom
  (eglot-autoshutdown t)                  ; stop the server with its last buffer
  (eglot-sync-connect nil)                ; connect asynchronously
  (eglot-connect-timeout 120)             ; eglot-jl's first run installs LanguageServer.jl
  (eglot-events-buffer-config '(:size 0 :format short))   ; no event log (perf)
  (eglot-code-action-indications '(eldoc-hint))           ; no fringe/margin lightbulbs
  (eglot-ignored-server-capabilities '(:inlayHintProvider)) ; M-x eglot-inlay-hints-mode to opt in
  :bind (:map eglot-mode-map
         ("C-c l r" . eglot-rename)
         ("C-c l a" . eglot-code-actions)
         ("C-c l f" . eglot-format)
         ("C-c l d" . eldoc)
         ("C-c l h" . eldoc-doc-buffer))
  :config
  ;; Java debugging: dape's `jdtls' config needs jdtls to load the java-debug
  ;; plugin (it then advertises vscode.java.resolveClasspath).  The jar comes
  ;; from `make emacs-adapters'; without it the default plain jdtls entry is used.
  (when-let* ((jar (car (file-expand-wildcards
                         (expand-file-name
                          "debug-adapters/java-debug/com.microsoft.java.debug.plugin-*.jar"
                          user-emacs-directory)))))
    (add-to-list 'eglot-server-programs
                 `((java-mode java-ts-mode)
                   . ("jdtls" :initializationOptions (:bundles [,jar]))))))

;; Larger reads from server processes (LSP responses are big).
(setq read-process-output-max (* 1024 1024))


;; ----------------------------------------------------------
;; Formatting - apheleia (format on save, async, cursor-stable)
;; ----------------------------------------------------------
;; https://github.com/radian-software/apheleia
;; Table matches nvim's conform.nvim: ruff (Python), prettier (JS/TS/JSON/
;; YAML/Markdown), stylua (Lua), taplo (TOML), terraform fmt.  Like nvim,
;; C/C++ are left alone; Java and shell have no installed formatter.
(use-package apheleia
  :config
  (dolist (m '(python-mode python-ts-mode))
    (setf (alist-get m apheleia-mode-alist) 'ruff))
  (setf (alist-get 'terraform-mode apheleia-mode-alist) 'terraform)
  (dolist (m '(markdown-mode gfm-mode markdown-ts-mode))
    (setf (alist-get m apheleia-mode-alist) 'prettier-markdown))
  (dolist (m '(c-mode c++-mode c-ts-mode c++-ts-mode
               java-mode java-ts-mode sh-mode bash-ts-mode))
    (setf (alist-get m apheleia-mode-alist nil 'remove) nil))
  (apheleia-global-mode 1))


;; ----------------------------------------------------------
;; Linting - ruff diagnostics alongside pyright
;; ----------------------------------------------------------
;; https://github.com/erickgnavar/flymake-ruff
;; eglot replaces the buffer's flymake backends with its own, so add ruff
;; from `eglot-managed-mode-hook' (after eglot has set up), Python only.
(use-package flymake-ruff
  :preface
  (defun kwb/flymake-ruff-maybe ()
    "Add the ruff flymake backend in Python buffers managed by eglot."
    (when (derived-mode-p 'python-base-mode)
      (flymake-ruff-load)))
  :hook (eglot-managed-mode . kwb/flymake-ruff-maybe))


;; ----------------------------------------------------------
;; Per-project environments - envrc (direnv)
;; ----------------------------------------------------------
;; https://github.com/purcell/envrc
;; Buffer-local environment from each project's .envrc: uv/.venv activation,
;; node_modules/.bin on PATH, secrets.  direnv is in the Brewfile.  pyright
;; finds .venv on its own; this is for everything that runs a binary.
(use-package envrc
  :hook (after-init . envrc-global-mode))


;; ----------------------------------------------------------
;; Debugging - dape (Debug Adapter Protocol)
;; ----------------------------------------------------------
;; https://github.com/svaante/dape  (GNU ELPA)
;; Adapters, by language:
;;   Python  debugpy        per project: uv add --dev debugpy
;;   C/C++   lldb-dap       ships with the Xcode Command Line Tools (below)
;;   JS/TS   js-debug-node  make emacs-adapters
;;   Java    jdtls          make emacs-adapters + the eglot bundle entry above
;; `M-x dape' prompts for a config name; `C-c d' is the command map.
(use-package dape
  :bind-keymap ("C-c d" . dape-global-map)
  :custom
  (dape-key-prefix nil)                   ; bound above instead of gud's C-x C-a
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t)
  :config
  (dape-breakpoint-global-mode)
  (add-hook 'dape-compile-hook #'kill-buffer)
  ;; lldb-dap lives in the CLT/Xcode toolchain, not on PATH.  Append its
  ;; directory to `exec-path' so it is found without shadowing Homebrew.
  (let ((lldb (ignore-errors
                (string-trim (shell-command-to-string "xcrun -f lldb-dap 2>/dev/null")))))
    (when (and lldb (file-executable-p lldb))
      (add-to-list 'exec-path (file-name-directory lldb) t))))


;; ----------------------------------------------------------
;; Julia
;; ----------------------------------------------------------
;; https://github.com/JuliaEditorSupport/julia-emacs
(use-package julia-mode)

;; https://github.com/non-Jedi/eglot-jl
;; Teaches eglot to run LanguageServer.jl from its own depot environment.  The
;; first `eglot' in a Julia buffer downloads and precompiles the server (slow;
;; watch *EGLOT ... stderr*); later starts are quick.
(use-package eglot-jl
  :after eglot
  :config
  (eglot-jl-init))

;; https://github.com/tpapp/julia-repl  (C-c C-z REPL, C-c C-c send region)
(use-package julia-repl
  :hook (julia-mode . julia-repl-mode)
  :config
  (julia-repl-set-terminal-backend 'vterm))


;; ----------------------------------------------------------
;; Compilation & misc
;; ----------------------------------------------------------

;; Render ANSI color in *compilation* (built in since Emacs 28).
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
(setq compilation-scroll-output 'first-error)

(defun kwb/dev-mode-hook ()
  "Settings shared by all programming modes."
  (subword-mode 1))   ; camelCase-aware word motion
(add-hook 'prog-mode-hook #'kwb/dev-mode-hook)


(provide 'dev)

;;; dev.el ends here
