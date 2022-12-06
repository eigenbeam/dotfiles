;;; packages --- basic set of packages
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Navigation enhancements
;; ----------------------------------------------------------

;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :config
  (setq dashboard-set-footer nil)
  (setq dashboard-projects-backend 'projectile)
  (add-to-list 'dashboard-items '(projects . 5))
  (setq projectile-switch-project-action 'projectile-dired)
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
  :pin melpa-stable
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

;; TODO: vterm-toggle

;; https://github.com/justbur/emacs-which-key/
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (which-key-setup-side-window-right))


;; ----------------------------------------------------------
;; Completions & Syntax Checking
;; ----------------------------------------------------------
;;
;; https://company-mode.github.io/
(use-package company
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-tooltip-idle-delay 0)
  (setq company-idle-delay 0)
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
  :pin melpa-stable
  :bind
  ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0")
  (setq magit-push-always-verify nil))

;; https://gitlab.com/pidu/git-timemachine
(use-package git-timemachine)

;; https://github.com/bbatsov/projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
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

;; TODO: org, org-babel, org-restclient


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