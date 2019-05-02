;; Initialize packages
(require 'package)
(add-to-list 'package-archives
	     ;'("marmalade" . "https://marmalade-repo.org/packages/")
	     '("melpa" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Pop-up auto completion
(global-company-mode)
(setq company-idle-delay nil)
(global-set-key (kbd "M-/") #'company-complete)
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "C-n") 'company-select-next)
     (define-key company-active-map (kbd "C-p") 'company-select-previous)))

;; mode default directories
(add-to-list 'load-path "~/.config/emacs/elisp")

;; Reasonable font size
(set-face-attribute 'default nil :height 110)

;; Never show startup screen
(set 'inhibit-startup-screen t)

;; Enable improved IDO
(require 'ido)
(ido-mode t)
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-use-faces nil) ;; Disable ido faces
(setq flx-ido-threshhold 1000)

;; Disable GUI
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Disable saving backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Human friendly kill buffer
(defun kill-buffer-and-its-windows (buffer)
    "Kill BUFFER and delete its windows.  Default is `current-buffer'.
   BUFFER may be either a buffer or its name (a string)."
    (interactive (list (read-buffer "Kill buffer: " (current-buffer) 'existing)))
    (setq buffer  (get-buffer buffer))
    (if (buffer-live-p buffer)            ; Kill live buffer only.
	(let ((wins  (get-buffer-window-list buffer nil t))) ; On all frames.
	  (when (and (buffer-modified-p buffer)
		     (fboundp '1on1-flash-ding-minibuffer-frame))
	    (1on1-flash-ding-minibuffer-frame t)) ; Defined in `oneonone.el'.
	  (when (kill-buffer buffer)      ; Only delete windows if buffer killed.
	    (dolist (win  wins)           ; (User might keep buffer if modified.)
	      (when (window-live-p win)
		;; Ignore error, in particular,
		;; "Attempt to delete the sole visible or iconified frame".
		(condition-case nil (delete-window win) (error nil))))))
      (when (interactive-p)
	(error "Cannot kill buffer.  Not a live buffer: `%s'" buffer))))

(substitute-key-definition 'kill-buffer 'kill-buffer-and-its-windows global-map)

;; Cool colors
(load-theme 'solarized-dark t)

;; TRAMP settings
(setq tramp-default-method "ssh")
(add-to-list 'backup-directory-alist
	     (cons tramp-file-name-regexp nil))
(setq tramp-auto-save-directory temporary-file-directory)

(setq explicit-shell-file-name "/bin/bash")

; Dired settings
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq dired-listing-switches "-alGh --group-directories-first")

;; Auto update all buffers after file changes on disk
(global-auto-revert-mode t)

;; Disable all alarms
(setq ring-bell-function 'ignore)

;; Enable region narrowing
(put 'narrow-to-region 'disabled nil)

;; Nicer mark word
(defun my-mark-current-word (&optional arg allow-extend)
  "Put point at beginning of current word, set mark at end."
  (interactive "p\np")
  (setq arg (if arg arg 1))
  (if (and allow-extend
	   (or (and (eq last-command this-command) (mark t))
	       (region-active-p)))
      (set-mark
       (save-excursion
	 (when (< (mark) (point))
	   (setq arg (- arg)))
	 (goto-char (mark))
	 (forward-word arg)
	 (point)))
    (let ((wbounds (bounds-of-thing-at-point 'word)))
      (unless (consp wbounds)
	(error "No word at point"))
      (if (>= arg 0)
	  (goto-char (car wbounds))
	(goto-char (cdr wbounds)))
      (push-mark (save-excursion
		   (forward-word arg)
		   (point)))
      (activate-mark))))
(global-set-key (kbd "M-q") 'my-mark-current-word)

;; Mark word and incremental search
(defun isearch-yank-symbol ()
  "Put symbol at current point into search string."
  (interactive)
  (let ((sym (symbol-at-point)))
    (if sym
	(progn
	  (setq isearch-regexp t
		isearch-string (regexp-quote (symbol-name sym))
		isearch-message (mapconcat 'isearch-text-char-description isearch-string "")
		isearch-yank-flag t))
      (ding)))
  (isearch-search-and-update))
(defun isearch-current-symbol (&optional partialp)
    "Incremental search forward with symbol under point.
    
  Prefixed with \\[universal-argument] will find all partial
  matches."
    (interactive "P")
    (let ((start (point)))
      (isearch-toggle-case-fold)
      (isearch-forward-regexp nil 1)
      (isearch-yank-symbol)
      (isearch-toggle-case-fold)))
(defun isearch-current-symbol-back (&optional partialp)
  (interactive "P")
  (let ((start (point)))
    (isearch-toggle-case-fold)
    (isearch-backward-regexp nil 1)
    (isearch-yank-symbol)
    (isearch-toggle-case-fold)))

(global-set-key (kbd "M-s") 'isearch-current-symbol)
(global-set-key (kbd "M-r") 'isearch-current-symbol-back)

;; Enable scrolling down line by line like in far
(defun my-scroll-line-down ()
  (interactive)
  (scroll-down-line))
					;  (previous-line))
(global-set-key (kbd "M-n") 'my-scroll-line-up)
					; and similar to scroll up
(defun my-scroll-line-up ()
  (interactive)
  (scroll-up-line))
					;  (next-line))
(global-set-key (kbd "M-p") 'my-scroll-line-down)

;; Nice caret(cursor) symbol
(set-default 'cursor-type 'bar)

;; 80-symbols guideline
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(define-globalized-minor-mode global-fci-mode
  fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; Remove selected text when start typing like all normal editors do
(delete-selection-mode 1)

;; Tabs are evil
(setq-default indent-tabs-mode nil)

;; Don't truncate lines
(set-default 'truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; llvm syntax highlighting
;(require 'llvm-mode)
;(require 'tablegen-mode)

;; Ediff will use only windows not frames
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Normal scrolling with mouse wheel
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Indentation
(add-hook 'java-mode-hook (lambda () (setq c-basic-offset 2)))
(setq sh-basic-offset '2)

;; Show matching parens
(show-paren-mode t)

;; Use simple answers for hard questions
(defalias 'yes-or-no-p 'y-or-n-p)

;; Run ediff on marked dired files
(defun dired-ediff-marked-files ()
  "Run ediff on marked ediff files."
  (interactive)
  (set 'marked-files (dired-get-marked-files))
  (when (= (safe-length marked-files) 2)
    (ediff-files (nth 0 marked-files) (nth 1 marked-files)))

  (when (= (safe-length marked-files) 3)
    (ediff3 (buffer-file-name (nth 0 marked-files))
	    (buffer-file-name (nth 1 marked-files))
	    (buffer-file-name (nth 2 marked-files)))))
(defun dired-ediff-marked-dirs ()
  "Run ediff on marked ediff files."
  (interactive)
  (set 'marked-files (dired-get-marked-files))
  (when (= (safe-length marked-files) 2)
    (ediff-directories (nth 0 marked-files) (nth 1 marked-files) ""))

  (when (= (safe-length marked-files) 3)
    (ediff-directories3
     (buffer-file-name (nth 0 marked-files))
     (buffer-file-name (nth 1 marked-files))
     (buffer-file-name (nth 2 marked-files)))))

(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-subword-mode 1)

;; CIDER
(setq cider-font-lock-dynamically '(macro core function var))
(setq cider-jdk-src-paths '("/usr/lib/jvm/java-8-openjdk/"
                            "/home/igor/work/Clojure/clojure-1.8.0-sources.jar"
                            "/home/igor/work/Clojure/"))

;; Clang format
;(require 'clang-format)
;(global-set-key [C-M-tab] 'clang-format-region)
;(setq clang-format-executable "/usr/local/bin/clang-format")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (smooth-scrolling smooth-scroll yaml-mode company cider solarized-theme flx-ido))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
