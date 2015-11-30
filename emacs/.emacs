(require 'server)
(unless (server-running-p)
  (server-start))

;; disable the tool bars and such
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

;; show a clock for full screen
(display-time-mode 1)

;; set up ido mode
(require `ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

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
      (add-to-list 'default-frame-alist '(font .  "Akkurat-Mono-10" ))
      (set-face-attribute 'default t :font "Akkurat-Mono-10"))
  (progn
    (add-to-list 'default-frame-alist '(font .  "Akkurat Mono-12" ))
    (set-face-attribute 'default t :font "Akkurat Mono-12"))
  )

;; show line numbers
(require 'linum)
(global-linum-mode 1)

(setq default-tab-width 2)

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

;; Add melpa and marmalade as sources for package.el
(require 'package)
(mapc (lambda(p) (push p package-archives))
      '(("melpa" . "https://melpa.milkbox.net/packages/")))
(package-refresh-contents)
(package-initialize)

;; install use-package if it isn't installed.
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)
(use-package centered-window-mode
  :ensure t)

(use-package color-theme-modern
  :ensure color-theme-modern
  :config)

;;(load-theme 'ramangalahy t t)
;;(enable-theme 'ramangalahy)
;;(load-theme 'infodoc t t)
;;(enable-theme 'infodoc)
;;(load-theme 'greiner t t)
;;(enable-theme 'greiner)
(load-theme 'snow t t)
(enable-theme 'snow)

(use-package centered-window-mode
  :ensure t)

(use-package fsharp-mode
  :ensure t)


(use-package adaptive-wrap
  :ensure t)

(use-package pandoc-mode
  :ensure t)

(add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)

(use-package markdown-mode
  :ensure t)

(add-hook 'markdown-mode-hook 'pandoc-mode)
(add-hook 'markdown-mode-hook
          '(lambda ()
             (progn
               (adaptive-wrap-prefix-mode 1)
               (visual-line-mode 1))))

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

(use-package polymode
  :ensure t)

(use-package ace-jump-mode
  :ensure t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)


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

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(markdown-command "pandoc -c d:/code/configs/emacs/github-markdown.css -s -t html5"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "SystemWindow")))))
