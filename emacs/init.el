;;  ██             ██   ██               ██
;; ░░             ░░   ░██              ░██
;; ███ █████████  ███ ██████      █████ ░██
;;░░██░░██    ░██░░██░░░██░      ██░░░██░██
;; ░██ ░██    ░██ ░██  ░██      ░███████░██
;; ░██ ░██    ░██ ░██  ░██      ░██░░░░ ░██
;; ░███░██    ░███░███ ░░██  ██ ░░█████░░██
;; ░░░ ░░     ░░░ ░░░   ░░  ░░    ░░░░  ░░

(add-to-list 'exec-path "~/bin") ;; put global in there

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

(defvar myPackages
  '(better-defaults
    elpy
    flycheck
    py-autopep8)
  )

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

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
;; (global-flycheck-mode)
(setq require-final-newline t)
(setq column-number-mode t)

;; line endings
(defun unix-file ()
  "Change the current buffer to Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'unix t))

(defun dos-file ()
  "Change the current buffer to DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'dos t))

(defun mac-file ()
  "Change the current buffer to Mac line-ends."
  (interactive)
    (set-buffer-file-coding-system 'mac t))

;; Mutt
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))
(defun mail-mode-fill-col ()
    (setq fill-column 72))
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(add-hook 'mail-mode-hook          'turn-on-auto-fill)
(add-hook 'mail-mode-hook          'mail-mode-fill-col)
(add-hook 'mail-mode-hook          'mail-abbrevs-setup)
(add-hook 'mail-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("^[ \t]*>[ \t]*>[ \t]*>.*$"
                                       (0 'mail-multiply-quoted-text-face))
                                      ("^[ \t]*>[ \t]*>.*$"
                                                         (0 'mail-double-quoted-text-face))))))

;; Hex editing

(defun buffer-binary-p (&optional buffer)
  "Return whether BUFFER or the current buffer is binary.

A binary buffer is defined as containing at least on null byte.

Returns either nil, or the position of the first null byte."
  (with-current-buffer (or buffer (current-buffer))
    (save-excursion
      (goto-char (point-min))
      (search-forward (string ?\x00) nil t 1))))

(defun hexl-if-binary ()
  "If `hexl-mode' is not already active, and the current buffer
is binary, activate `hexl-mode'."
  (interactive)
  (unless (eq major-mode 'hexl-mode)
    (when (buffer-binary-p)
      (hexl-mode))))

(add-hook 'find-file-hooks 'hexl-if-binary)

;; syntax highlighting and code styling

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

(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode t
      )

(use-package cuda-mode
  :ensure t
  :mode (("\\.cu\\'"  . cuda-mode))
  :mode (("\\.cuh\\'"  . cuda-mode))
)

(require 'opencl-mode)
(add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))

(defun astyle-this-buffer ()
  ;; from https://gist.github.com/blueabysm/e69ceb62e41d68cc81ea2c6791db25c2
  "Use astyle command to auto format C/C++ code."
  (interactive "r")
  (if (executable-find "astyle")
      (shell-command-on-region
       (point-min) (point-max)
       (concat
        "astyle"
        " --style=linux"
        " --indent=tab"
        " --indent-col1-comments"
        " --indent-preprocessor"
        " --indent-preproc-cond"
        " --pad-oper"
        " --pad-header"
        " --keep-one-line-blocks"
        " --align-pointer=type"
        " --align-reference=type"
        " --suffix=none")
       (current-buffer) t
       (get-buffer-create "*Astyle Errors*") t)
    (message "Cannot find binary \"astyle\", please install first.")))

(defun astyle-before-save ()
  "Artistic styling before saving."
  (interactive)
  (when (member major-mode '(cc-mode c++-mode c-mode cuda-mode opencl-mode))
    (astyle-this-buffer)))

(add-hook 'c-mode-common-hook (lambda () (add-hook 'before-save-hook 'astyle-before-save)))

;; Python, after https://realpython.com/emacs-the-best-python-editor/#configuration-and-packages

(elpy-enable)
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
