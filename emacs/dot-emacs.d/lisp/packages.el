;;; packages --- basic set of packages
;;; Commentary:
;;; Code:

;; Required for :diminish keyword in use-package
(use-package diminish)

;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
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
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (which-key-setup-side-window-right)
  (setq which-key-idle-delay 0.5))


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
;; Docker and Kubernetes
;; ----------------------------------------------------------
;;
;; https://github.com/Silex/docker.el
;; (use-package docker)

;; https://github.com/spotify/dockerfile-mode
;; (use-package dockerfile-mode)

;; https://github.com/meqif/docker-compose-mode
;; (use-package docker-compose-mode)

;; https://github.com/chrisbarrett/kubernetes-el
;; (use-package kubernetes
;;   :commands (kubernetes-overview))


(provide 'packages)

;;; packages.el ends here
