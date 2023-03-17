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

;;; Code:

(add-to-list 'exec-path "~/bin") ;; put global in there
(add-to-list 'load-path "~/.emacs.d/custom")
(setq exec-path (cons "/usr/local/bin" exec-path))
(setq backup-directory-alist '(("." . (substitute-in-file-name "/tmp/${USER}/emacs"))))
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

(when (not package-archive-contents)
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
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

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(when (>= emacs-major-version 27)
  (require 'display-line-numbers)
  (defcustom display-line-numbers-exempt-modes
    '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
    "Major modes on which to disable the linum mode, exempts them from global requirement"
    :group 'display-line-numbers
    :type 'list
    :version "green")
  (defun display-line-numbers--turn-on ()
    "turn on line numbers but exempt certain major modes defined in `display-line-numbers-exempt-modes'"
    (if (and (not (member major-mode display-line-numbers-exempt-modes))
             (not (minibufferp)))
        (display-line-numbers-mode)))
  (global-display-line-numbers-mode)
  )

;; Put backup files neatly away (https://emacs.stackexchange.com/a/36)
(let ((backup-dir (getenv "EMACSBD"))
      (auto-saves-dir (getenv "EMACSSD")) )
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)) )
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*", auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir)
  )

(setq backup-by-copying t               ; Don't delink hardlinks
      delete-old-versions t             ; Clean up the backups
      version-control t                 ; Use version numbers on backups,
      kept-new-versions 2               ; keep some new versions
      kept-old-versions 2)              ; and some old ones, too

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
   '("1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65" "50e9ef789d599d39a9ecb6e983757306ea19198d1a8f182be7fd3242b613f00e" "66881e95c0eda61d34aa7f08ebacf03319d37fe202d68ecf6a1dbfd49d664bc3" "bc40f613df8e0d8f31c5eb3380b61f587e1b5bc439212e03d4ea44b26b4f408a" "c82092aedda488cad216113d2d1b676c78b45569204a1350ebe8bef7bbd1b564"))
 '(flycheck-markdown-markdownlint-cli-executable "markdownlint-cli2")
 '(package-selected-packages
   '(langtool toml-mode multi-line adafruit-wisdom all-the-icons anzu better-defaults bug-hunter clean-aindent-mode company company-anaconda company-jedi company-lua company-math company-quickhelp-terminal company-shell company-terraform counsel counsel-pydoc counsel-projectile csv-mode dockerfile-mode dtrt-indent edit-indirect editorconfig elisp-format elisp-lint ess fill-column-indicator flycheck flycheck-julia flycheck-pycheckers flycheck-pyflakes flycheck-yamllint flymake-sass gcode-mode helm helm-gtags highlight-doxygen iedit julia-formatter julia-mode lua-mode neotree night-owl-theme olivetti opencl-mode pandoc-mode poetry poly-R poly-ansible poly-rst py-autopep8 pyvenv-auto rainbow-mode rdf-prefix rst rust-mode scad-mode snakemake-mode typescript-mode undo-tree unicode-troll-stopper use-package v-mode virtualenv volatile-highlights ws-butler yaml-mode yasnippet zygospore)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun unfill-paragraph
    (&optional region)
  "Take a multi-line REGION and make a single line of text of it."
  (interactive (progn (barf-if-buffer-read-only)
                      '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

;; tab-completion
(setq company-quickhelp-mode t)

;; Appearance

(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default column-number-mode t)
(setq-default require-final-newline t)
(setq require-final-newline t)
;; (setq sentence-end-double-space nil)

;; how wide should the text fields be?
(setq-default fill-column 79)
(setq fill-column 79)

(use-package all-the-icons
  :if (display-graphic-p))

;; adapt to non-Unix line endings

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
  "Set mail message width to 65 cols."
  (setq fill-column 65))
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook 'mail-mode-fill-col)
(add-hook 'mail-mode-hook 'mail-abbrevs-setup)
(add-hook 'mail-mode-hook (lambda ()
                            (font-lock-add-keywords
                             nil
                             '(("^[ \t]*>[ \t]*>[ \t]*>.*$" (0 'mail-multiply-quoted-text-face))
                               ("^[ \t]*>[ \t]*>.*$" (0 'mail-double-quoted-text-face))))))

;; Hex editing

(defun buffer-binary-p
    (&optional
     buffer)
  "Return whether BUFFER or the current buffer is binary."
  (with-current-buffer (or buffer
                           (current-buffer))
    (save-excursion (goto-char (point-min))
                    (search-forward (string ?\x00) nil t 1))))

(defun hexl-if-binary ()
  "Activate `hexl-mode' if the current buffer is binary."
  (interactive)
  (unless (eq major-mode 'hexl-mode)
    (when (buffer-binary-p)
      (hexl-mode))))

(add-hook 'find-file-hooks 'hexl-if-binary)

;; Linting

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t))

(use-package flycheck-pycheckers
  :after flycheck
  :ensure t
  :init
  (with-eval-after-load 'flycheck
    (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup)
    )
  (setq flycheck-pycheckers-checkers
        '(
          pyflakes
          )
        )
  )

;; Python dependency management and packaging
(use-package poetry
  :ensure t)

(setq compilation-scroll-output 'first-error)

;; syntax highlighting and code styling

(setq c-default-style "linux" c-basic-offset 4 tab-width 4 indent-tabs-mode t)

(require 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
(add-to-list 'auto-mode-alist '("\\.tsv\\'" . csv-mode))

(use-package cuda-mode
  :ensure t
  :mode (("\\.cu\\'"  . cuda-mode))
  :mode (("\\.cuh\\'"  . cuda-mode)))

(require 'highlight-doxygen)
(add-to-list 'auto-mode-alist '("\\Doxyfile\\'" . highlight-doxygen-mode))

(require 'gcode-mode)
(add-to-list 'auto-mode-alist '("\\.gcode\\'" . gcode-mode))

(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json\\'"   . json-mode))
(add-to-list 'auto-mode-alist '("\\.jsonld\\'" . json-mode))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'"       . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
)


;; center text fields in window
(use-package olivetti
  :diminish
  :commands olivetti-mode
  :config
  (setq-default olivetti-body-width 125)
  (setq-default olivetti-minimum-body-width 40)
  (setq olivetti-body-width 125)
  (setq olivetti-minimum-body-width 40)
)

(require 'olivetti-mode)
(add-to-list 'auto-mode-alist '("\\.el\\'" . olivetti-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . olivetti-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . olivetti-mode))

(require 'opencl-mode)
(add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))

(require 'rst)
(add-to-list 'auto-mode-alist '("\\.rst\\'" . rst))

(require 'turtle-mode)
(add-to-list 'auto-mode-alist '("\\.turtle\\'" . turtle-mode))

(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

;; LaTeX handling

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; disable vc-git
(setq vc-handled-backends ())
(put 'downcase-region 'disabled nil)

;;; Commentary:

;;; init.el ends here
