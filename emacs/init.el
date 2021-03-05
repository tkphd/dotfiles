;;; init.el --- configuration for emacs
;;
;;  ██             ██   ██               ██
;; ░░             ░░   ░██              ░██
;; ███ █████████  ███ ██████      █████ ░██
;;░░██░░██    ░██░░██░░░██░      ██░░░██░██
;; ░██ ░██    ░██ ░██  ░██      ░███████░██
;; ░██ ░██    ░██ ░██  ░██      ░██░░░░ ░██
;; ░███░██    ░███░███ ░░██  ██ ░░█████░░██
;; ░░░ ░░     ░░░ ░░░   ░░  ░░    ░░░░  ░░

(add-to-list 'exec-path "~/bin") ;; put global in there
(add-to-list 'load-path "~/.emacs.d/custom")
(setq exec-path (cons "/usr/local/bin" exec-path))
(require 'subr-x)

(when (and (version<  "25" emacs-version)
           (version< emacs-version "26.3"))
  ;; Hack to prevent TLS error with Emacs 26.1 and 26.2 and gnutls 3.6.4 and above
  ;; see https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341
  (with-current-buffer (url-retrieve-synchronously "https://api.github.com/users/syl20bnr/repos")
    (when (string-empty-p (buffer-string))
      (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(when (not package-archive-contents) (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(if (version< emacs-version "24.4")
  (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags)
)

(require 'setup-general)
(require 'setup-cedet)
(require 'setup-editing)

(require 'volatile-highlights)
(volatile-highlights-mode t)

(load-theme 'tsdh-dark)

(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)

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
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c82092aedda488cad216113d2d1b676c78b45569204a1350ebe8bef7bbd1b564" "66881e95c0eda61d34aa7f08ebacf03319d37fe202d68ecf6a1dbfd49d664bc3" "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65" "50e9ef789d599d39a9ecb6e983757306ea19198d1a8f182be7fd3242b613f00e" "1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" "bc40f613df8e0d8f31c5eb3380b61f587e1b5bc439212e03d4ea44b26b4f408a" default)))
 '(package-selected-packages
   (quote
    (fill-column-indicator night-owl-theme rust-mode zygospore helm-gtags helm yasnippet ws-butler dtrt-indent volatile-highlights use-package undo-tree iedit counsel-projectile company clean-aindent-mode anzu))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defvar myPackages
  '(better-defaults
    flycheck
    py-autopep8)
  )

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; linting
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; text filling (line wrapping)
(setq-default fill-column 79)
(setq sentence-end-double-space nil)
(setq compilation-scroll-output 'first-error)

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

;; Display columns, and set default wrap width
(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default column-number-mode t)
(setq-default fill-column 79)
(setq fill-column 79)
(setq-default require-final-newline t)
(setq require-final-newline t)

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

(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(add-hook 'c-mode-common-hook (lambda () (add-hook 'before-save-hook 'astyle-before-save)))

;; Python, after https://realpython.com/emacs-the-best-python-editor/#configuration-and-packages
;; (elpy-enable)
;;# (require 'py-autopep8)
;;# (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; disable vc-git
(setq vc-handled-backends ())
(put 'downcase-region 'disabled nil)


;;; Commentary:
;; flycheck is a bit of a nuisance
