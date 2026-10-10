;;; early-init.el --- Pre-GUI startup tuning  -*- lexical-binding: t -*-
;;; Commentary:
;; Runs before the first frame and before package.el.  Only what must happen
;; that early lives here: startup GC, the native-comp cache location, and frame
;; defaults (so the GUI never flashes a tool bar before hiding it).
;;; Code:

;; init.el sets archives and calls `package-initialize' itself.
(setq package-enable-at-startup nil)

;; Generous GC while loading; `emacs-startup-hook' restores a working value.
(setq gc-cons-threshold (* 256 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024))))

;; Keep native-comp output under var/ with the rest of no-littering's state.
(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name "var/eln-cache/" user-emacs-directory))))
(setq native-comp-async-report-warnings-errors 'silent)

;; Frame defaults, applied before the first frame exists.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t)

;;; early-init.el ends here
