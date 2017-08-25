
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


; Window resizing!
; `C-x ^’ makes the current window taller (‘enlarge-window’)
; `C-x }’ makes it wider (‘enlarge-window-horizontally’)
; `C-x {’ makes it narrower (‘shrink-window-horizontally’)
; repeat last command C-x z, and then z z z z z


(cd (expand-file-name "~/"))

(add-to-list 'load-path "~/emacs-lisp/")

(set-foreground-color "white")
(set-background-color "black")
(set-cursor-color "spring green")
(set-face-background 'region "forest green")
(set-face-background 'highlight "forest green")

(setq last-last-command nil)

(setq kill-emacs-query-functions
      (cons (lambda () (yes-or-no-p "Really kill Emacs? "))
	    kill-emacs-query-functions))

(defun copy-rectangle-as-kill (start end)
  "Save the rectangle with corners at point and mark as if killed,
but don't kill it.  Calling from program, supply two args START and
END,
buffer positions.  If `interprogram-cut-function' is non-nil, also save
the text for a window system cut and paste."
  (interactive "r")
  (let ((rectangle (extract-rectangle start end)))
    (if rectangle
        (progn
          (kill-new (concat (car rectangle) "\n"))
          (mapcar
           (lambda (rect-line)
             (kill-append (concat rect-line "\n") nil))
           (cdr rectangle))))) nil)


(defmacro nr-adjoin (var item)
  `(setq ,var (adjoin ,item ,var :test #'equal)))

(defun revert-buffer-no-ask ()
  (interactive nil)
  (revert-buffer t t t)
)

(defun scroll-up-be-smart ()
  (interactive nil)
  (condition-case nil
     (scroll-up)
    (error (goto-char (point-max)))))

(defun scroll-down-be-smart ()
  (interactive nil)
  (condition-case nil
     (scroll-down)
    (error (goto-char (point-min)))))


(setq mac-command-modifier 'meta)

(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(transient-mark-mode -1)
(column-number-mode 1)
(line-number-mode 1)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default truncate-partial-width-windows nil)
(setq inhibit-startup-message t)

(ido-mode 'buffers)

(require 'cl) ; cl is emacs-standard.
(require 'custom)
(require 'web-mode)
(require 'markdown-mode)

(require 'windmove)
  (windmove-default-keybindings)
  (setq windmove-window-distance-delta 2)

(require 'font-lock)
(require 'cc-mode)
(require 'cperl-mode)

(setq cperl-invalid-face (quote off))

(autoload 'nuke-trailing-whitespace "whitespace" nil t)

(autoload 'counter "counter" t nil)

(when window-system
  (setq paren-sexp-mode t))

(setq-default mode-line-buffer-identification '(" %12b"))
(nr-adjoin completion-ignored-extensions ".class")
(nr-adjoin completion-ignored-extensions ".exe")
(nr-adjoin completion-ignored-extensions ".hi")

(setq auto-mode-alist
      (mapcar #'(lambda (this-mode-pair)
                  (let ((this-mode-ext  (car this-mode-pair))
                        (this-mode-name (cdr this-mode-pair)))
                    (if (equal this-mode-name 'c-mode)
                      (cons this-mode-ext 'c++-mode)
                      this-mode-pair)))
              auto-mode-alist))

(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.hsc$"    . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))

(setq auto-mode-alist `(("\\.js\\'" . js-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.es6\\'" . js-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.g\\'" . java-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.ml\\w?" . tuareg-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.xul$" . sgml-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.cs$" . csharp-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.XML$" . sgml-mode) ,@auto-mode-alist))
(setq auto-mode-alist `(("\\.ts\\'" . typescript-mode) ,@auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))

(setq web-mode-content-types-alist
      '(("jsx"  . ".*\\.jsx\\'")))

(setq web-mode-enable-auto-quoting nil)

(defun my-c++-mode-hook ()
  (c-toggle-hungry-state 1)
  (c-set-style "k&r")
  (setq c-basic-offset 4)
  (c-set-offset 'case-label '+)
)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

(defun my-perl-mode-hook ()
  (setq tab-width 4)
  (c-toggle-hungry-state 1)
  (local-set-key (read-kbd-macro "RET") 'newline-and-indent)
  ; (local-set-key (read-kbd-macro "<backspace>") 'c-electric-backspace)
)

(add-hook 'perl-mode-hook 'my-perl-mode-hook)
(add-hook 'cperl-mode-hook 'my-perl-mode-hook)

(put 'narrow-to-region 'disabled nil) ; Enable `narrow-to-region' ("C-x n n").
(put 'eval-expression  'disabled nil) ; Enable `eval-expression' ("M-ESC").
(put 'upcase-region    'disabled nil) ; Enable `upcase-region'    ("C-x C-u"). 
(put 'downcase-region  'disabled nil) ; Enable `downcase-region'  ("C-x C-l").

(global-set-key (read-kbd-macro "C-c g") 'goto-line)
(global-set-key "\C-ccf" 'font-lock-fontify-buffer)
(global-set-key "\C-cr" 'counter)
(global-set-key "\M-#" 'calc-dispatch)
(global-set-key [mouse-2] nil)
(global-set-key [mouse-3] nil)
(global-set-key "\C-cb" 'revert-buffer-no-ask)
(global-set-key "\C-cn" 'kill-rectangle)
(global-set-key "\C-cm" 'string-rectangle)
(global-set-key (read-kbd-macro "<next>") 'scroll-up-be-smart)
(global-set-key (read-kbd-macro "<prior>") 'scroll-down-be-smart)

; meta commands
; (global-set-key "\M-l" 'windmove-right)
; (global-set-key "\M-h" 'windmove-left)

(setq options-save-faces t)

; '(font-lock-support-mode (quote lazy-lock-mode))
; '(lazy-lock-defer-contextually nil)
; '(lazy-lock-defer-time 1)

(setq indent-line-function 'tab-to-tab-stop)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(bbdb-completion-display-record nil)
 '(cperl-brace-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-indent-level 4)
 '(font-lock-maximum-decoration t)
 '(global-font-lock-mode t nil (font-lock))
 '(next-line-add-newlines nil)
 '(search-highlight nil)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cperl-array-face ((t (:weight bold))))
 '(cperl-hash-face ((t (:weight bold))))
 '(cperl-nonoverridable-face ((t (:foreground "orchid1"))))
 '(paren-face-match ((((class color)) (:weight bold))))
 '(paren-face-mismatch ((t nil)))
 '(paren-face-no-match ((t nil))))

(set-face-foreground 'font-lock-string-face "light steel blue")

(show-paren-mode 1)

(setq face-stuff
  '((font-lock-string-face        "light steel blue"    nil nil)
    (font-lock-keyword-face       "LightSkyBlue1"       nil nil)
    (font-lock-function-name-face "light steel blue"    nil t)
    (font-lock-variable-name-face "white"               nil nil)
    (font-lock-type-face          "SkyBlue1"            nil nil)
;    (font-lock-reference-face     "white"               nil t)
    (font-lock-comment-face       "medium sea green"    nil nil)
    (font-lock-preprocessor-face  "white"               nil t)
    (font-lock-constant-face      "white"               nil t)
;    (jde-java-font-lock-number-face "white"             nil nil)
    ))

(mapcar (lambda (fi)
          (set-face-foreground (nth 0 fi) (nth 1 fi))
          (set-face-bold-p (nth 0 fi) (nth 3 fi))
          )
        face-stuff)

(setq show-paren-style 'expression)
(set-face-bold-p 'show-paren-match t)
(set-face-background 'show-paren-match nil)

(require 'tramp)

(setq backup-directory-alist
      `((".*" . "~/.emacs-autosave/")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs-autosave/" t)))

; go get golang.org/x/tools/cmd/goimports
(require 'go-mode-autoloads)
(setq gofmt-command "/Users/mike/work/gopath/bin/goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(defun my-go-hook ()
  (c-toggle-hungry-state 1)
  ; (local-set-key (read-kbd-macro "DEL") 'c-electric-delete)
  ; (local-set-key (read-kbd-macro "RET") 'newline-and-indent)
)
(add-hook 'go-mode-hook 'my-go-hook)


