;;  ██             ██   ██               ██
;; ░░             ░░   ░██              ░██
;; ███ █████████  ███ ██████      █████ ░██
;;░░██░░██    ░██░░██░░░██░      ██░░░██░██
;; ░██ ░██    ░██ ░██  ░██      ░███████░██
;; ░██ ░██    ░██ ░██  ░██      ░██░░░░ ░██
;; ░███░██    ░███░███ ░░██  ██ ░░█████░░██
;; ░░░ ░░     ░░░ ░░░   ░░  ░░    ░░░░  ░░

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents)
)

(unless (package-installed-p 'use-package)
  (package-install 'use-package)
)
(require 'use-package)
(setq use-package-always-ensure t)
(setq column-number-mode t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)

(if (version< emacs-version "24.4")
  (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags)
)

(require 'setup-cedet)
(require 'setup-editing)

(load-theme 'tsdh-dark)

;; Put backup files neatly away
(let ((backup-dir (getenv "EMACSBD"))
      (auto-saves-dir (getenv "EMACSSD")))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

(setq column-number-mode t)

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu))
  )
)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

;; custom highlighting
(use-package cuda-mode
  :ensure t
  :mode (("\\.cu\\'"  . cuda-mode)
         ("\\.cuh\\'" . cuda-mode))
)

(require 'opencl-mode)
(add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
)

(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode t)
