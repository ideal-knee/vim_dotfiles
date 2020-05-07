;; User info
(setq user-full-name "Dan Kee")
(setq user-mail-address "dan@dankee.com")

;; Packages
(require 'cl)
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(defvar dkee/packages '(cider
                        clojure-mode
                        dockerfile-mode
                        ein
                        elixir-mode
                        ;; ensime
                        find-file-in-project
                        find-file-in-repository
                        flx-ido
                        haskell-mode
                        hy-mode
                        json-mode
                        magit
                        markdown-mode
                        neotree
                        racket-mode
                        rainbow-delimiters
                        rust-mode
                        slime
                        smex
                        smartparens
                        swift-mode
                        yaml-mode )
  "Default packages" )

(defun dkee/packages-installed-p ()
  (loop for pkg in dkee/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))
(unless (dkee/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg dkee/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Start up
(setq inhibit-splash-screen t
      inhibit-startup-message t
      initial-scratch-message nil)

;; Display
(menu-bar-mode -1)
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))
(load-theme 'wombat t)
(setq linum-format "%d ")
(global-linum-mode t)

;; Editing
(delete-selection-mode t)
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
(setq make-backup-files nil)
(setq require-final-newline t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(electric-pair-mode 1)
(electric-indent-mode 0)
(defun vim-join-line ()
  (interactive)
  (next-line)
  (join-line) )
(global-set-key (kbd "M-j") 'vim-join-line)

;; Navigation
(global-set-key (kbd "C-M-e") 'scroll-up-line)
(global-set-key (kbd "C-M-y") 'scroll-down-line)
(global-set-key (kbd "M-:") 'goto-line)
(global-set-key (kbd "C-c k") 'windmove-up)
(global-set-key (kbd "C-c j") 'windmove-down)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c h") 'windmove-left)

;; Smex mode (enhanced M-x)
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Ido (fuzzy finding)
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching 1)
(setq ido-use-faces nil)
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; Smartparens
(require 'smartparens-config)
(define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
(define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
(define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
(define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
(define-key smartparens-mode-map (kbd "C-S-d") 'sp-beginning-of-sexp)
(define-key smartparens-mode-map (kbd "C-S-a") 'sp-end-of-sexp)
;;(define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
(define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
(define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)
(define-key smartparens-mode-map (kbd "C-M-n") 'sp-next-sexp)
(define-key smartparens-mode-map (kbd "C-M-p") 'sp-previous-sexp)
(define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
(define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)
(define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
;;(define-key smartparens-mode-map (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)
(define-key smartparens-mode-map (kbd "C-\\") 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-\\") 'sp-forward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-]") 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-]") 'sp-backward-barf-sexp)
(define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
(define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
(define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
(define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)
;;(define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
;;(define-key smartparens-mode-map (kbd "C-<left_bracket>") 'sp-select-previous-thing)
;;(define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)
(define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
(define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)
(add-hook 'clojure-mode-hook    #'smartparens-mode)
(add-hook 'cider-repl-mode-hook #'smartparens-mode)
(add-hook 'emacs-lisp-mode-hook #'smartparens-mode)

;; Neotree (file tree explorer)
(defun neotree-find-in-project-dir ()
  "Open NeoTree to current buffer relative to the git root."
  (interactive)
  (let ((project-dir (ffip-get-project-root-directory))
        (file-name (buffer-file-name)))
    (if project-dir
      (progn
        (neotree-dir project-dir)
        (neotree-find file-name))
      (message "Could not find git project root."))))
(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-get-project-root-directory))
        (file-name (buffer-file-name)))
    (if project-dir
      (neotree-dir project-dir)
      (message "Could not find git project root."))))
(global-set-key [f8] 'neotree-toggle)
(global-set-key (kbd "C-c f") 'neotree-find-in-project-dir)
(global-set-key (kbd "C-c r") 'neotree-project-dir)
(setq neo-window-fixed-size nil)

;; All Lisps
(show-paren-mode t)

;; Steel Bank Common Lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(slime-setup '(slime-fancy))
(put 'context 'lisp-indent-function 1)
(put 'test-that-it 'lisp-indent-function 1)

;; Clojure
(add-hook 'clojure-mode-hook #'company-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(setq cider-prompt-for-symbol nil)
(setq cider-lein-parameters "repl :headless :host localhost")
(require 'clojure-mode)
(define-clojure-indent
  (-> 1)
  (->> 0) )

;; Ruby
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))

;; Markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))

;; ;; Scala
;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Octave
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;; Hy
(add-to-list 'auto-mode-alist '("\\.hy$" . hy-mode))

;; Customizations
(setq custom-file "~/.emacs.d/customizations.el")
(if (not (file-exists-p custom-file))
  (write-region "" nil custom-file) )
(load custom-file)

;; Keep keybindings the same with or without tmux
(defun no-tmux ()
  (interactive)
  (global-unset-key (kbd "C-a"))
  (global-set-key (kbd "C-a a") 'move-beginning-of-line) )
(when (eq system-type 'darwin)
  (no-tmux) )
