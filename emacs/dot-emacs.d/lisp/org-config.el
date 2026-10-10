;;; org-config.el --- Org-mode configuration  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; ----------------------------------------------------------
;; Basic Org-Mode Configuration
;; ----------------------------------------------------------

(use-package org
  :ensure nil  ; built in (Org 9.8 in Emacs 31)
  :custom
  ;; Directory settings
  (org-directory "~/org")
  (org-default-notes-file (concat org-directory "/notes.org"))

  ;; Visual settings
  (org-startup-indented t)  ; Clean visual indentation
  (org-hide-emphasis-markers t)  ; Hide markup like *bold* and /italic/
  (org-pretty-entities t)  ; Show UTF-8 characters for entities
  (org-ellipsis " ▾")  ; Nicer folding indicator

  ;; Behavior settings
  (org-log-done 'time)  ; Timestamp when completing TODOs
  (org-return-follows-link t)  ; RET follows links

  ;; Source code blocks
  (org-src-fontify-natively t)  ; Syntax highlighting in code blocks
  (org-src-tab-acts-natively t)  ; Tab works properly in code blocks
  (org-src-preserve-indentation t)  ; Keep code indentation
  (org-edit-src-content-indentation 0)  ; No extra indent in code blocks

  ;; Agenda settings
  (org-agenda-files '("~/org"))  ; Where to look for agenda items

  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c l" . org-store-link))

  :config
  ;; electric-pair-mode is global; don't pair `<' so `<s TAB' structure
  ;; templates still work.
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local electric-pair-inhibit-predicate
                          (lambda (c)
                            (if (char-equal c ?<)
                                t
                              (electric-pair-default-inhibit c)))))))


;; ----------------------------------------------------------
;; Org-Modern - Beautiful Visual Styling
;; ----------------------------------------------------------

;; https://github.com/minad/org-modern
(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star 'replace)  ; Replace asterisks with nicer bullets
  (org-modern-table nil)  ; Keep default tables
  (org-modern-timestamp t)  ; Prettier timestamps
  (org-modern-todo t)  ; Prettier TODO keywords
  (org-modern-tag t))  ; Prettier tags


;; ----------------------------------------------------------
;; Org-Appear - Smart Emphasis Marker Hiding
;; ----------------------------------------------------------

;; https://github.com/awth13/org-appear
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t)  ; Show full link when cursor is on it
  (org-appear-autosubmarkers t)  ; Show/hide markers as needed
  (org-appear-autoentities t))  ; Show entities as needed


(provide 'org-config)

;;; org-config.el ends here
