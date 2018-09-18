;;  ██             ██   ██               ██
;; ░░             ░░   ░██              ░██
;; ███ █████████  ███ ██████      █████ ░██
;;░░██░░██    ░██░░██░░░██░      ██░░░██░██
;; ░██ ░██    ░██ ░██  ░██      ░███████░██
;; ░██ ░██    ░██ ░██  ░██      ░██░░░░ ░██
;; ░███░██    ░███░███ ░░██  ██ ░░█████░░██
;; ░░░ ░░     ░░░ ░░░   ░░  ░░    ░░░░  ░░

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(when (not package-archive-contents) (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
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
(require 'volatile-highlights)
(volatile-highlights-mode t)

(load-theme 'tsdh-dark)

;; Put backup files neatly away (https://emacs.stackexchange.com/a/36)
(let ((backup-dir (getenv "EMACSBD"))
      (auto-saves-dir (getenv "EMACSSD")) )
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)) )
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir) )
(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 '(custom-safe-themes
   (quote
    ("66881e95c0eda61d34aa7f08ebacf03319d37fe202d68ecf6a1dbfd49d664bc3"
     "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65"
     "50e9ef789d599d39a9ecb6e983757306ea19198d1a8f182be7fd3242b613f00e"
     "1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5"
     "bc40f613df8e0d8f31c5eb3380b61f587e1b5bc439212e03d4ea44b26b4f408a"
     default)))
 '(package-selected-packages
   (quote
    (zygospore helm-gtags helm yasnippet ws-butler dtrt-indent
     volatile-highlights use-package undo-tree iedit
     counsel-projectile company clean-aindent-mode anzu))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; text filling (line wrapping)
(setq-default fill-column 80)
(setq sentence-end-double-space nil)

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

;; linting
(global-flycheck-mode)
(setq require-final-newline t)
(setq column-number-mode t)

;; syntax highlighting
(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode t
      )

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
         ("\\.md\\'"       . markdown-mode)
         ("\\.rst\\'"      . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         )
  :init (setq markdown-command "pandoc")
)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
