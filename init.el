;;  ██             ██   ██              ██
;; ░░             ░░   ░██             ░██
;; ███ █████████  ███ ██████     █████ ░██
;;░░██░░██    ░██░░██░░░██░     ██░░░██░██
;; ░██ ░██    ░██ ░██  ░██     ░███████░██
;; ░██ ░██    ░██ ░██  ░██     ░██░░░░ ░██
;; ░███░██    ░███░███ ░░██  ██░░█████░░██
;; ░░░ ░░     ░░░ ░░░   ░░  ░░   ░░░░  ░░

;; Prerequisites:
;; M-x package-install cuda-mode

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://stable.melpa.org/packages/")
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

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)

(if (version< emacs-version "24.4")
  (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags)
)

;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory))
)
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t))
)
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

;; custom highlighting, etc.
(autoload 'cuda-mode "cuda-mode.el")
(add-to-list 'auto-mode-alist '("\\.cl\\'" . cuda-mode)
             'auto-mode-alist '("\\.cu\\'" . cuda-mode)
             'auto-mode-alist '("\\.cuh\\'" . cuda-mode)
)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))
;;  :init (setq markdown-command "multimarkdown"))
