;; Add melpa and marmalade as sources for package.el

(require 'package)
(mapc (lambda(p) (push p package-archives))
      '(("melpa" . "http://melpa.milkbox.net/packages/")))
(package-refresh-contents)
(package-initialize)

;; install use-package if it isn't installed.
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;; show line numbers
(require 'linum)
(global-linum-mode 1)

;; load monokai theme
(use-package monokai-theme
  :ensure monokai-theme
  :config
  (progn (load-theme 'monokai t)))

(use-package quack
  :ensure t)
(require 'quack)
(setq quack-fontify-style 'emacs
      quack-default-program "csi"
      quack-newline-behavior 'newline)

;; set fn key as the same as control
(if (string-equal system-type "darwin")
    (progn
      (setenv "PATH" (concat "/usr/local/bin" ";" (getenv "PATH")) t)
      (add-to-list 'exec-path "/usr/local/bin/")
      (setq ns-function-modifier 'control)
      )
  )

;; default window split is vertical
(setq split-width-threshold nil)

;; 4 space tabbing in c-mode
(setq-default c-basic-offset 4)

;; no tabs
(setq-default indent-tabs-mode nil)

;; Always do syntax highlighting
(global-font-lock-mode 1)

;; Also highlight parens
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

;;; This is the binary name of my scheme implementation
(setq scheme-program-name "csi")

;; install csharpmode
(use-package csharp-mode
  :ensure t)

;; sublimity
(use-package sublimity
  :ensure sublimity)

(require 'sublimity)
(require 'sublimity-scroll)

;; speedbar
(use-package sr-speedbar
  :ensure sr-speedbar)

(require 'sr-speedbar)
;;(global-set-key (kbd "M-s") 'sr-speedbar-toggle)

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
