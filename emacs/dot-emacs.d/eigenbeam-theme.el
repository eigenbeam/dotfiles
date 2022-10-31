(deftheme eigenbeam
  "Created 2022-02-05.")

;; Belafonte Day
;; Builtin Solarized Light
;; Material
;; Novel
;; Pencil Light
;; Raycast Light
;; Tomorrow

(custom-theme-set-faces
 'eigenbeam
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#F7F1DF" :foreground "dark green" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "SRC" :family "Hack"))))
 '(cursor ((t (:background "dim gray"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial")) (t (:family "Sans Serif"))))
 '(escape-glyph ((t (:foreground "dark green"))))
 '(homoglyph ((t (:foreground "dark green" :inverse-video t))))
 '(minibuffer-prompt ((t (:foreground "dark blue"))))
 '(highlight ((t (:background "#282a2e" :inverse-video nil))))
 '(region ((t (:extend t :inverse-video nil :background "#373b41"))))
 '(shadow ((t (:foreground "#969896"))))
 '(secondary-selection ((t (:extend t :background "#282a2e"))))
 '(trailing-whitespace ((t (:inherit (whitespace-trailing)))))
 '(font-lock-builtin-face ((t (:foreground "dark slate gray"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#969896" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "RoyalBlue4" :slant normal))))
 '(font-lock-constant-face ((t (:foreground "DarkOrchid4"))))
 '(font-lock-doc-face ((t (:foreground "steel blue"))))
 '(font-lock-function-name-face ((t (:foreground "gray42"))))
 '(font-lock-keyword-face ((t (:foreground "purple4"))))
 '(font-lock-negation-char-face ((t (:foreground "#81a2be"))))
 '(font-lock-preprocessor-face ((t (:foreground "#b294bb"))))
 '(font-lock-regexp-grouping-backslash ((t (:foreground "#f0c674"))))
 '(font-lock-regexp-grouping-construct ((t (:foreground "#b294bb"))))
 '(font-lock-string-face ((t (:foreground "blue"))))
 '(font-lock-type-face ((t (:foreground "gray42"))))
 '(font-lock-variable-name-face ((t (:foreground "dark green"))))
 '(font-lock-warning-face ((t (:foreground "gold3" :weight bold))))
 '(button ((t (:inherit (link)))))
 '(link ((t (:underline t))))
 '(link-visited ((t (:inherit link :foreground "dark blue"))))
 '(fringe ((t (:foreground "#969896" :background "#22a224a427a7"))))
 '(header-line ((t (:inherit mode-line-inactive :foreground "forest green"))))
 '(tooltip ((t (:background "#1d1f21" :foreground "#f0c674" :inverse-video t))))
 '(mode-line ((t (:weight normal :box (:line-width 1 :color "#373b41" :style nil) :foreground "forest green" :background "gray"))))
 '(mode-line-buffer-id ((t (:foreground "forest green"))))
 '(mode-line-emphasis ((t (:slant italic :foreground "#c5c8c6"))))
 '(mode-line-highlight ((t (:foreground "forest green" :box nil :weight bold))))
 '(mode-line-inactive ((t (:weight normal :foreground "forest green" :background "light gray" :inherit (mode-line)))))
 '(isearch ((t (:background "#1d1f21" :foreground "#f0c674" :inverse-video nil))))
 '(isearch-fail ((t (:inherit font-lock-warning-face :background "#1d1f21" :inverse-video nil))))
 '(lazy-highlight ((t (:background "#1d1f21" :foreground "#8abeb7" :inverse-video nil))))
 '(match ((t (:background "#1d1f21" :foreground "#81a2be" :inverse-video nil))))
 '(next-error ((t (:inherit region))))
 '(query-replace ((t (:inherit isearch)))))

(provide-theme 'eigenbeam)
