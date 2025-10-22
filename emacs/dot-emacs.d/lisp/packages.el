;;; packages --- basic set of packages
;;; Commentary:
;;; Code:

;; Required for :diminish keyword in use-package
(use-package diminish)

;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :defer 0.1
  :init
  (setq exec-path-from-shell-arguments nil)
  :config
  (exec-path-from-shell-initialize))


;; ----------------------------------------------------------
;; Navigation enhancements
;; ----------------------------------------------------------

;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :config
  (setq dashboard-set-footer nil)
  (setq dashboard-projects-backend 'projectile)
  (add-to-list 'dashboard-items '(projects . 5))
  (dashboard-setup-startup-hook))

;; https://github.com/bbatsov/crux
(use-package crux
  :bind (("M-p" . crux-smart-open-line-above)
         ("M-n" . crux-smart-open-line)))

;; https://github.com/abo-abo/ace-window
(use-package ace-window
  :init
  (bind-key "M-o" 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)))

;; https://github.com/Fuco1/smartparens
(use-package smartparens
  :defer 2
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-paren-mode t))

;; https://github.com/akermu/emacs-libvterm
(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback (* 32 1024)))

;; https://github.com/justbur/emacs-which-key/
(use-package which-key
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

;; https://gitlab.com/tsc25/undo-tree
(use-package undo-tree
  :diminish undo-tree-mode
  :custom
  (undo-tree-auto-save-history t)
  (undo-tree-history-directory-alist
   `(("." . ,(no-littering-expand-var-file-name "undo-tree-hist/"))))
  :config
  (global-undo-tree-mode))

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
;; Completions & Syntax Checking
;; ----------------------------------------------------------
;;
;; https://company-mode.github.io/
(use-package company
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-tooltip-idle-delay 0.2)
  (setq company-idle-delay 0.2)
  (setq company-tooltip-align-annotations t)
  (global-set-key (kbd "<C-tab>") 'company-complete))

;; http://www.flycheck.org/en/latest/
(use-package flycheck
  :diminish flycheck-mode
  :init (add-hook 'after-init-hook 'global-flycheck-mode))


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

;; https://gitlab.com/pidu/git-timemachine
(use-package git-timemachine)

;; https://github.com/bbatsov/projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-switch-project-action 'projectile-dired)
  (projectile-mode +1))


;; ----------------------------------------------------------
;; Language-specific modes
;; ----------------------------------------------------------
;;
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :pin melpa
  :mode "\\.md\\'")

;; https://github.com/pashky/restclient.el
(use-package restclient)

;; https://github.com/emacsorphanage/terraform-mode
(use-package terraform-mode)

;; https://github.com/yaml/yaml-mode
(use-package yaml-mode)


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
