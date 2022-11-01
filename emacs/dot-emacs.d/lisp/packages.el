;;; packages --- basic set of packages
;;; Commentary:
;;; Code:

;; https://github.com/abo-abo/ace-window
(use-package ace-window
  :ensure t
  :init
  (bind-key "M-o" 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


;; TODO
(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t))

;; https://company-mode.github.io/
(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-tooltip-idle-delay 0)
  (setq company-idle-delay 0)
  (setq company-tooltip-align-annotations t)
  (global-set-key (kbd "<C-tab>") 'company-complete))

;; TODO
(use-package crux
  :ensure t
  :bind (("M-p" . crux-smart-open-line-above)
         ("M-n" . crux-smart-open-line)))

;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; https://github.com/purcell/default-text-scale
(use-package default-text-scale
  :ensure t
  :config (default-text-scale-mode))

;; https://github.com/Silex/docker.el
;; (use-package docker
;;   :ensure t)

;; https://github.com/spotify/dockerfile-mode
;; (use-package dockerfile-mode
;;   :ensure t)

;; https://github.com/meqif/docker-compose-mode
;; (use-package docker-compose-mode
;;   :ensure t)

;; https://github.com/seagle0128/doom-modeline
;; Post-install:
;; M-x all-the-icons-install-fonts
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1)
;;   :config
;;   (setq doom-modeline-github t)
;;   (setq doom-modeline-github-interval (* 15 30)))

;; http://www.flycheck.org/en/latest/
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init (add-hook 'after-init-hook 'global-flycheck-mode))

;; https://gitlab.com/pidu/git-timemachine
(use-package git-timemachine
  :ensure t)

;; https://github.com/chrisbarrett/kubernetes-el
;; (use-package kubernetes
;;   :ensure t
;;   :commands (kubernetes-overview))

;; https://magit.vc/
(use-package magit
  :ensure t
  :pin melpa-stable
  :bind
  ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0")
  (setq magit-push-always-verify nil))

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  :pin melpa-stable
  :bind (("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)))

;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :ensure t
  :pin melpa
  :mode "\\.md\\'")

;; TODO: org, org-babel, org-restclient

;; https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;; https://github.com/pashky/restclient.el
;; (use-package restclient
;;   :ensure t)

;; https://github.com/Fuco1/smartparens
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-paren-mode t))

;; https://github.com/TxGVNN/terraform-doc
;; (use-package terraform-doc
;;   :ensure t)

;; https://github.com/emacsorphanage/terraform-mode
;; (use-package terraform-mode
;;   :ensure t)

;; https://github.com/akermu/emacs-libvterm
(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback (* 32 1024)))

;; TODO: vterm-toggle

;; https://github.com/justbur/emacs-which-key/
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (which-key-setup-side-window-right))

;; https://github.com/yaml/yaml-mode
(use-package yaml-mode
  :ensure t)

(provide 'packages)

;;; packages.el ends here
