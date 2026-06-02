;;; packages --- basic set of packages
;;; Commentary:
;;; Code:

;; Required for :diminish keyword in use-package
(use-package diminish)

;; https://github.com/purcell/exec-path-from-shell
;; Needed for GUI-launched Emacs (Dock, Spotlight) which doesn't inherit shell env vars
(use-package exec-path-from-shell
  :if (display-graphic-p)
  :defer 0.1
  :custom
  (exec-path-from-shell-arguments '("-l"))
  :config
  (exec-path-from-shell-initialize))


;; ----------------------------------------------------------
;; Navigation enhancements
;; ----------------------------------------------------------

;; https://github.com/bbatsov/crux
(use-package crux
  :defer t
  :bind (("M-p" . crux-smart-open-line-above)
         ("M-n" . crux-smart-open-line)))

;; https://github.com/abo-abo/ace-window
(use-package ace-window
  :defer t
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :defer t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; https://github.com/akermu/emacs-libvterm
;; Plain terminal; also the terminal backend used by claude-code-ide below.
(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback (* 32 1024)))

;; which-key is built-in as of Emacs 30
(use-package which-key
  :ensure nil
  :defer 1
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.5)
  :config
  (which-key-mode +1)
  (which-key-setup-side-window-right))

;; https://github.com/emacsorphanage/anzu
(use-package anzu
  :diminish anzu-mode
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode +1))

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


;; ----------------------------------------------------------
;; In-buffer completion (corfu + cape) & diagnostics (flymake)
;; ----------------------------------------------------------
;;
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
  (corfu-popupinfo-mode))

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
;;
;; https://github.com/oantolin/embark
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))


;; ----------------------------------------------------------
;; Git & Project Management
;; ----------------------------------------------------------
;;
;; https://magit.vc/
(use-package magit
  :bind
  ("C-c g" . magit-status))

;; https://github.com/dandavison/magit-delta
(use-package magit-delta
  :after magit
  :hook (magit-mode . magit-delta-mode))

(use-package forge
  :after magit)

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

;; Built-in project.el (replaces projectile).  C-c p keeps the old muscle memory.
(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map)
  :custom
  (project-switch-commands 'project-dired))


;; ----------------------------------------------------------
;; Claude Code (claude-code-ide.el)
;; ----------------------------------------------------------
;;
;; https://github.com/manzaltu/claude-code-ide.el
;; Runs the Claude Code CLI in a vterm (default backend) and bridges Emacs to
;; Claude over MCP: xref, diagnostics, treesit/imenu, project info, and
;; ediff-based diff review.  project.el-native (one instance per project).
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))


;; ----------------------------------------------------------
;; Language-specific modes
;; ----------------------------------------------------------
;;
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :pin melpa
  :mode "\\.md\\'")

;; https://github.com/pashky/restclient.el
(use-package restclient
  :defer t)

;; https://github.com/emacsorphanage/terraform-mode
(use-package terraform-mode
  :defer t)

;; https://github.com/yaml/yaml-mode
(use-package yaml-mode
  :defer t)


;; ----------------------------------------------------------
;; Tree-sitter (Emacs 29+)
;; ----------------------------------------------------------
;;
;; https://github.com/renzmann/treesit-auto
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))


(provide 'packages)

;;; packages.el ends here
