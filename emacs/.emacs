;; Add melpa and marmalade as sources for package.el
(require 'server)
(unless (server-running-p)
  (server-start))

(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
;(unless (eq system-type 'windows-nt)
;    (set-selection-coding-system 'utf-8))
(prefer-coding-system 'utf-8)

;; Set a nice default font
(if (eq system-type 'windows-nt)
    (progn
      (add-to-list 'default-frame-alist '(font .  "Lucida Grande Mono-10" ))
      (set-face-attribute 'default t :font "Lucida Grande Mono-10"))
  (progn
    (add-to-list 'default-frame-alist '(font .  "Lucida Grande Mono-12" ))
    (set-face-attribute 'default t :font "Lucida Grande Mono-12"))
  )

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

(setq default-tab-width 2)

;; Backup settings
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

;; load monokai theme
(use-package monokai-theme
  :ensure monokai-theme
  :config
  (progn
    (load-theme 'monokai t)
    ))

(use-package ample-theme
  :ensure ample-theme
  :config
  (progn
    ;(load-theme 'ample t)
    ))

(use-package cyberpunk-theme
  :ensure cyberpunk-theme
  :config
  (progn
    ;(load-theme 'cyberpunk t)
    ))

(use-package flatland-theme
  :ensure flatland-theme
  :config
  (progn
    ;(load-theme 'flatland t)
    ))

(use-package centered-window-mode
  :ensure t)

(use-package quack
  :ensure t)
(require 'quack)
(setq quack-fontify-style 'emacs
      quack-default-program "csi"
      quack-newline-behavior 'newline)

;; set fn key as the same as control
(if (string-equal system-type 'darwin)
    (progn
      (setenv "PATH" (concat "/usr/local/bin" ";" (getenv "PATH")) t)
      (add-to-list 'exec-path "/usr/local/bin/")
      (setq ns-function-modifier 'control)
      )
  )

;; trailing whitespace
(setq-default show-trailing-whitespace t)

;; truncate, we ain't care.
(set-default 'truncate-lines t)

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

(use-package fsharp-mode
  :ensure t)

(use-package haskell-mode
  :ensure t)

(require 'haskell)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(use-package ghc
  :ensure t)

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(use-package ac-haskell-process
  :ensure t)

(add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
(add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'haskell-interactive-mode))

(use-package mmm-mode
  :ensure t)

(add-hook 'haskell-mode-hook 'my-mmm-mode)

(mmm-add-classes
 '((literate-haskell-bird
    :submode text-mode
    :front "^[^>]"
    :include-front true
    :back "^>\\|$"
    )
   (literate-haskell-latex
    :submode literate-haskell-mode
    :front "^\\\\begin{code}"
    :front-offset (end-of-line 1)
    :back "^\\\\end{code}"
    :include-back nil
    :back-offset (beginning-of-line -1)
    )))

(defun my-mmm-mode ()
  ;; go into mmm minor mode when class is given
  (make-local-variable 'mmm-global-mode)
  (setq mmm-global-mode 'true))

(setq mmm-submode-decoration-level 0)

(use-package exec-path-from-shell
  :ensure t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(use-package go-mode
  :ensure t)

(add-hook 'before-save-hook 'gofmt-before-save)

(use-package go-autocomplete
  :ensure t)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(use-package go-eldoc
  :ensure t)

(add-hook 'go-mode-hook 'go-eldoc-setup)

(use-package powershell
  :ensure t)

(setq powershell-indent 2)

(use-package yaml-mode
  :ensure t)

(use-package polymode
  :ensure t)

;; jekyll mode and markdown-mode for editing github blogs
(use-package markdown-mode
  :ensure t)

(use-package adaptive-wrap
  :ensure t)

(add-hook 'markdown-mode-hook
          '(lambda ()
             (progn
               (adaptive-wrap-prefix-mode 1)
               (visual-line-mode 1))))

(use-package jekyll-modes
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.md$" . jekyll-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.html" . jekyll-html-mode))

;; install csharpmode
(use-package csharp-mode
  :ensure t)

(use-package dylan-mode
  :ensure t)

(if (eq system-type 'windows-nt)
    (setq inferior-dylan-program "\"C:/Program Files (x86)/Open Dylan/bin/dswank.exe\"")
  (setq inferior-dylan-program "~/bin/opendylan-2014.1/bin/dswank"))

(require 'dime)
(dime-setup '(dime-dylan dime-repl))

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

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(markdown-command "blackfriday-tool"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "#272822")))))
