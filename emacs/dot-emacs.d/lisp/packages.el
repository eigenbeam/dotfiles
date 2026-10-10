;;; packages.el --- General-purpose packages and Claude Code  -*- lexical-binding: t -*-
;;; Commentary:
;; Editing, navigation, completion, git, terminal, tree-sitter, Claude Code.
;; Language tooling (eglot, apheleia, dape, Julia) lives in dev.el.
;;; Code:

;; https://github.com/purcell/exec-path-from-shell
;; GUI-launched Emacs (Dock, Spotlight) does not inherit the shell environment.
;; Not deferred: eglot/vterm/magit need PATH as soon as the first file opens.
;; SSH_AUTH_SOCK lets magit push over ssh from a GUI launch.
(use-package exec-path-from-shell
  :if (display-graphic-p)
  :custom
  (exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-variables '("PATH" "MANPATH" "SSH_AUTH_SOCK"))
  :config
  (exec-path-from-shell-initialize))


;; ----------------------------------------------------------
;; Editing & navigation
;; ----------------------------------------------------------

(defun kwb/open-line-below ()
  "Open an indented line below the current one and move there."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun kwb/open-line-above ()
  "Open an indented line above the current one and move there."
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-n") #'kwb/open-line-below)
(global-set-key (kbd "M-p") #'kwb/open-line-above)

;; https://github.com/abo-abo/ace-window
(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; https://github.com/casouri/vundo -- visual undo tree over the built-in undo
(use-package vundo
  :bind ("C-x u" . vundo))

;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; https://github.com/Fuco1/dired-hacks
(use-package dired-subtree
  :after dired
  :bind (:map dired-mode-map
         ("<tab>" . dired-subtree-toggle)
         ("<backtab>" . dired-subtree-remove)))

;; Built in since Emacs 30.
(use-package which-key
  :ensure nil
  :defer 1
  :custom
  (which-key-idle-delay 0.5)
  :config
  (which-key-mode 1)
  (which-key-setup-side-window-right))


;; ----------------------------------------------------------
;; Terminal
;; ----------------------------------------------------------
;; https://github.com/akermu/emacs-libvterm
;; Plain terminal, and the backend claude-code-ide runs Claude in.  Compiles a
;; native module on first use: needs cmake + libvterm (both in the Brewfile).
(use-package vterm
  :bind ("C-c t" . vterm)
  :custom
  (vterm-always-compile-module t)   ; build on first use without prompting
  (vterm-max-scrollback 32768)
  (vterm-kill-buffer-on-exit t))


;; ----------------------------------------------------------
;; Tree-sitter (built in; Emacs 31 options replace treesit-auto)
;; ----------------------------------------------------------
;; `treesit-enabled-modes' t remaps every classic mode that has a *-ts-mode
;; twin (python -> python-ts-mode, c -> c-ts-mode, ...).  Grammars for every
;; language used here ship as sources in Emacs 31 and compile on first open
;; (needs git + a C compiler) into ~/.emacs.d/tree-sitter/.
(require 'treesit)
(setopt treesit-enabled-modes t
        treesit-auto-install-grammar 'always)


;; ----------------------------------------------------------
;; In-buffer completion (corfu + cape) & diagnostics (flymake)
;; ----------------------------------------------------------
;; https://github.com/minad/corfu
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  :config
  (corfu-popupinfo-mode)
  (corfu-history-mode))   ; recent picks first; persisted by savehist

;; https://github.com/minad/cape
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;; Built-in flymake; eglot drives it automatically in LSP buffers.
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
         ("M-g n" . flymake-goto-next-error)
         ("M-g p" . flymake-goto-prev-error)))


;; ----------------------------------------------------------
;; Minibuffer actions (embark)
;; ----------------------------------------------------------
;; https://github.com/oantolin/embark
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))


;; ----------------------------------------------------------
;; Git & projects
;; ----------------------------------------------------------
;; https://magit.vc/
(use-package magit
  :bind ("C-c g" . magit-status))

;; https://github.com/emacsmirror/git-timemachine
(use-package git-timemachine
  :defer t)

;; https://github.com/dgutov/diff-hl -- VC change bars in the (widened) fringe
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode))

;; Built-in project.el.  C-c p keeps the old projectile muscle memory.
(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map)
  :custom
  (project-switch-commands 'project-dired))


;; ----------------------------------------------------------
;; Claude Code (claude-code-ide.el)
;; ----------------------------------------------------------
;; https://github.com/manzaltu/claude-code-ide.el
;; Runs the Claude Code CLI in a vterm and bridges Emacs to Claude over MCP:
;; xref, flymake diagnostics, treesit/imenu, project info, current selection,
;; and ediff-based review of proposed edits.  project.el-native.  Not on MELPA;
;; installed with package-vc (`M-x package-vc-upgrade' to update).
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :custom
  (claude-code-ide-terminal-backend 'vterm)
  :config
  (claude-code-ide-emacs-tools-setup))


;; ----------------------------------------------------------
;; File-type modes without a built-in tree-sitter mode
;; ----------------------------------------------------------
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :mode "\\.md\\'")

;; https://github.com/emacsorphanage/terraform-mode
(use-package terraform-mode
  :defer t)


(provide 'packages)

;;; packages.el ends here
