(require 'server)
(unless (server-running-p)
  (server-start))

;; disable the tool bars and such
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

;; show a clock for full screen
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)

;; disable the audible bell
;; (setq visible-bell 1)
(setq ring-bell-function 'ignore)

;; auto-magically refresh all buffers
(global-auto-revert-mode t)

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
(prefer-coding-system 'utf-8)

;; show line numbers
(require 'linum)
(global-linum-mode 1)

(setq default-tab-width 2)

;; set fn key as the same as control
(if (string-equal system-type 'darwin)
    (progn
      (add-to-list 'exec-path "/usr/local/bin/")
      (add-to-list 'exec-path "/Users/zbrown/.local/bin/")
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
(setq package-enable-at-startup nil)
(setq package-archives
      '(("elpa"         . "http://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
        ("melpa"        . 5)
        ("elpa"         . 0)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package color-theme-modern
  :ensure color-theme-modern
  :config)

;;(load-theme 'ramangalahy t t)
;;(enable-theme 'ramangalahy)
;;(load-theme 'infodoc t t)
;;(enable-theme 'infodoc)
;;(load-theme 'greiner t t)
;;(enable-theme 'greiner)
;;(load-theme mac-classic t t)
;;(enable-theme 'mac-classic)
(load-theme 'snow t t)
(enable-theme 'snow)

(use-package exec-path-from-shell
  :ensure t)

(use-package adaptive-wrap
  :ensure t)

(add-hook 'html-mode-hook 'visual-line-mode)
(set-fill-column 120)

(use-package haskell-mode
  :ensure t
  :commands (haskell-mode)
  :init
  (add-hook 'haskell-mode-hook #'intero-mode)
  (add-hook 'haskell-mode-hook #'subword-mode)
  (setq haskell-stylish-on-save t))

(use-package intero
  :ensure t
  :commands (intero-mode)
  :diminish (intero-mode . "I"))

(use-package popwin
  :defer t
  :config
  (push 'haskell-interactive-mode popwin:special-display-config)
  (push 'intero-rep-mode popwin:special-display-config))

(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

;; (use-package scala-mode
;;   :ensure t)

;; (use-package sbt-mode
;;   :ensure t)

;; (use-package ensime
;;   :ensure t
;;   :pin melpa-stable)

;; (use-package polymode
;;   :ensure t)

;; (use-package ace-jump-mode
;;   :ensure t)
;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; (use-package sublimity
;;   :ensure sublimity)

;; (require 'sublimity)
;; (require 'sublimity-scroll)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
 '(package-selected-packages
   (quote
    (magit use-package intero hindent flycheck-haskell exec-path-from-shell ensime company-ghci color-theme-modern adaptive-wrap))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
