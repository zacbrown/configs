;; Add melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; show line numbers
(require 'linum)
(global-linum-mode 1)

;; load monokai theme
(load-theme 'monokai t)

;; 4 space tabbing in c-mode
(setq-default c-basic-offset 4)

;; no tabs
(setq-default indent-tabs-mode nil)

;; sublimity
(require 'sublimity)
(require 'sublimity-scroll)

(require 'sublimity-map)

;; speedbar
(require 'sr-speedbar)
(global-set-key (kbd "M-s") 'sr-speedbar-toggle)

;; rebind how page-up and page-down work

(defun sfp-page-down ()
  (interactive)
  (next-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun sfp-page-up ()
  (interactive)
  (previous-line
   (- (window-text-height)
      next-screen-context-lines)))

(global-set-key [next] 'sfp-page-down)
(global-set-key [prior] 'sfp-page-up)
