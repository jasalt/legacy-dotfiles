;;; TODO add major mode agnostic settings

;;;; Disable some Prelude defaults
(setq prelude-whitespace nil)
(setq prelude-flyspell nil)
(guru-mode 0)
(global-hl-line-mode 0)
(global-display-line-numbers-mode 0)
(global-nlinum-mode 0)

;;(beacon-mode -1)
;;(fringe-mode 10)

;; Extra package manager stuff

(prelude-require-package 'use-package)  ;; syntactic helper tool

;; * Quelpa
;; Build and install your Emacs Lisp packages on-the-fly and directly from source/github.
;; https://github.com/quelpa/quelpa
;;(quelpa '(hydra :repo "abo-abo/hydra" :fetcher github))
;; (prelude-require-package 'quelpa-use-package)


(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://github.com/quelpa/quelpa/raw/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; ref: config in quelpa developers stackemacs.el init file
;;      https://framagit.org/steckerhalter/steckemacs.el/-/blob/master/steckemacs.el


;;;; Matrix client config starts

;; Install `plz' HTTP library (not on MELPA yet).
;;(use-package plz
;;  :quelpa (plz :fetcher github :repo "alphapapa/plz.el"))

;; Install Ement.
;;(use-package ement
;;  :quelpa (ement :fetcher github :repo "alphapapa/ement.el"))

;;;; Matrix client config ends


;; (add-to-list 'default-frame-alist '(undecorated . t))  ;; set in init.el
(setq frame-resize-pixelwise t)

;; Fix ansi-term C-a keybinding with prelude stealing it
(add-hook 'term-mode-hook (lambda ()
                            (setq-local prelude-mode
                                        nil)))


;; Setup custom default theme
;; First comment out loading of default prelude theme
;; In .emacs.d/core/prelude-ui.el:
;; (when prelude-theme
;;   (load-theme prelude-theme t))

(prelude-require-package 'quasi-monochrome-theme)
(prelude-require-package 'use-package)
;;(load-theme 'quasi-monochrome)

(prelude-require-package 'twittering-mode)

;; Used in some Finnish words
(key-chord-define-global "yy" nil)
(key-chord-define-global "uu" nil)
(key-chord-define-global "xx" nil)

(key-chord-define-global "lj" nil) ;; .clj etc
(key-chord-define-global "xx" nil)

(global-unset-key (kbd "M-`"))
(global-set-key (kbd "M-`") 'other-frame)


;;;; Customize default config variables

(defmacro progn-on (platform &rest body)
  "Evaluate given expressions if running on given platform."
  (if (string-equal system-type platform)
      (cons 'progn body)))

;; Run emacs server so emacsclient can connect.
(load "server")
(setq server-name "jarkon-emacs")
(setq server-socket-dir "~/.emacs.d/server")
(unless (server-running-p) (server-start))

(scroll-bar-mode -1) ; Disable scroll bars
(setq cursor-type '(bar . 1))

(setq frame-title-format (list "%b"))
(prelude-require-package 'smartscan)

;; (disable-theme 'zenburn)
;; (prelude-require-package 'solarized-theme)
;; (load-theme 'solarized-dark)
;; (prelude-require-package 'idea-darkula-theme)
;; TODO bug with idea-darkula loading..
;; (load-theme 'idea-darkula)

;; Make scratch-buffer more convenient
(setq initial-scratch-message "")
(setq initial-major-mode 'org-mode)


;; Yank from linux selection to point when using middle mouse
;;(setq mouse-yank-at-point t)

;; Nicer mousewheel scrolling
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(defun show-or-create-scratch ()
  "Shows a scratch buffer or creates another one if visiting one."
  (interactive)
  (if (string-match "*scratch*" (buffer-name))
      (progn
        (switch-to-buffer (get-buffer-create (concat (buffer-name) "*")))
        (princ "Created a new scratch buffer."))
    (progn (switch-to-buffer
            (get-buffer-create "*scratch*")))))

(global-set-key (kbd "C-c <escape>") 'show-or-create-scratch)
(global-set-key (kbd "C-c `") 'show-or-create-scratch)  ;; terminal workaround

(progn-on
 "darwin"
 (setq ns-use-native-fullscreen nil)
 (setq mac-option-modifier 'nil
       mac-command-modifier 'meta
       mac-function-modifier 'hyper)
 (set-variable 'magit-emacsclient-executable
               "/usr/local/bin/emacsclient")
 (set-face-attribute 'default nil :font "Inconsolata-16")
 ;; Mac spotlight search workaround
 (global-unset-key (kbd " "))
 (global-set-key (kbd " ") 'just-one-space)
 )

(progn-on
 "gnu/linux"
                                        ;(set-face-attribute 'default nil :font "Mononoki Bold-16")

 ;; Fix exit delay "saving to x clipboard manager"
 ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Clipboard.html
 (setq x-select-enable-clipboard-manager nil)
 
 (set-variable 'magit-emacsclient-executable
               (concat dotfiles-folder "bin/ec"))
 (setq browse-url-browser-function 'browse-url-generic
       browse-url-generic-program "x-www-browser"))

(progn-on "windows-nt"
          (set-face-attribute 'default nil :font "Inconsolata-13")
          )

(defun transparency (value)
  "Set the transparency of the frame window.  VALUE = 0-100."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))
;;(transparency 90)

;; Pop marks faster by repeated spacing
;; Eg. C-u <space> <space> <space>
(setq set-mark-command-repeat-pop 't)

(global-set-key (kbd "<XF86Launch1>") 'writeroom-mode)
(global-set-key (kbd "H-m w") 'writeroom-mode)
(setq writeroom-width 90)

(global-set-key (kbd "H-m a") 'artist-mode)
(global-set-key (kbd "H-m o") 'org-mode)
(global-set-key (kbd "H-m t") 'text-mode)
(global-set-key (kbd "H-m q") 'fundamental-mode)
(global-set-key (kbd "H-m m") 'markdown-mode)
(global-set-key (kbd "H-m e") 'emacs-lisp-mode)
(global-set-key (kbd "H-m c") 'clojure-mode)
(global-set-key (kbd "H-m v") 'csv-mode)
(global-set-key (kbd "H-m x") 'xml-mode)
(global-set-key (kbd "H-m p") 'python-mode)
(global-set-key (kbd "H-m r") 'ruby-mode)
(global-set-key (kbd "H-m s") 'shell-script-mode)
(global-set-key (kbd "H-m j") 'javascript-mode)
(global-set-key (kbd "H-m h") 'html-mode)

(global-set-key (kbd "<C-M-backspace>") 'crux-top-join-line)
(global-set-key (kbd "C-c C-SPC") 'comment-or-uncomment-region)

;; Window splitting keys as seen in Terminator
(global-set-key (kbd "C-S-o") '(lambda ()
                                 (interactive)
                                 (split-window-vertically nil)))
(global-set-key (kbd "C-M-o") '(lambda ()
                                 (interactive)
                                 (split-window-horizontally nil)))
(global-set-key (kbd "C-M-w") '(lambda ()
                                 (interactive)
                                 (delete-window)))


;; Change panes by M-<num>
(prelude-require-package 'window-numbering)
(window-numbering-mode t)

(prelude-require-package 'multiple-cursors)
(setq mc/list-file (concat dotfiles-folder "emacs/mc-lists.el"))


;; TODO OSX support
(prelude-require-package 'smartscan)
(global-smartscan-mode 1)

(define-key smartscan-map (kbd "M-n") nil)
(define-key smartscan-map (kbd "M-p") nil)
(define-key smartscan-map (kbd "M-'") nil)

(define-key smartscan-map (kbd "s-n") 'smartscan-symbol-go-forward)
(define-key smartscan-map (kbd "s-p") 'smartscan-symbol-go-backward)
(define-key smartscan-map (kbd "s-'") 'smartscan-symbol-replace)

;; Jump to a word in window
(key-chord-define-global "jf" 'avy-goto-word-1)

;; Jump to next character, repeat the character to jump to next one.
;;(prelude-require-package 'iy-go-to-char)
(key-chord-define-global "jj" nil)
;;(key-chord-define-global "jj" 'iy-go-to-char)
;;(key-chord-define-global "hh" 'iy-go-to-char-backward)

(key-chord-define-global "jn" 'mc/mark-more-like-this-extended)
;; TODO 'mc/mark-more-like-this-extended for previous to make it work.
;; (key-chord-define-global "jp" 'mc/mark-previous-like-this)

(key-chord-define-global "jm" 'mc/mark-all-like-this)
(key-chord-define-global "jt" 'mc/mark-sgml-tag-pair)
(key-chord-define-global "kd" 'mc/edit-lines)



(prelude-require-package 'edit-server)
(edit-server-start) ; Edit server chromium extension
;; When editing text in Trello, use markdown mode.
(add-hook 'edit-server-start-hook
          '(lambda ()
             (if (string-match "trello.com/" (buffer-name))
                 (markdown-mode))))


;;;; File browsing
(prelude-require-package 'neotree)
(define-key global-map (kbd "C-x D") 'neotree-toggle)
(global-set-key (kbd "C-x F") 'nil)
(define-key global-map (kbd "C-x F") 'neotree-dir)

(defun dired-open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath)
                (w32-shell-execute "open" (replace-regexp-in-string "/" "\\"
                                                                    fPath t t)) )
              myFileList))
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )
              myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil))
                                (start-process "" nil "xdg-open" fPath)))
              myFileList))))))

(add-hook 'dired-mode-hook
          '(lambda ()
             (define-key dired-mode-map "0" 'dired-open-in-external-app)
             (define-key dired-mode-map (kbd "C-c C-c") 'wdired-change-to-wdired-mode)
             ))

(progn-on "darwin"
          (let ((terminal-app (concat dotfiles-folder "/osx/bin/iterm")))
            (defun open-file-path-in-terminal ()
              "Open current directory in dired mode in terminal application.
               Dismiss shell output buffer afterwards."
              (interactive)
              (start-process (concat dotfiles-folder "/osx/bin/iterm") nil
                             (concat dotfiles-folder "/osx/bin/iterm")
                             (file-truename default-directory)))))

(progn-on "gnu/linux"
          (defun open-file-path-in-terminal ()
            "Open current directory in dired mode in terminal application.
             Dismiss shell output buffer afterwards."
            (interactive)
            (start-process "terminator" nil "terminator"
                           (concat "--working-directory="
                                   (file-truename default-directory)))))

(define-key global-map (kbd "C-c 0") 'open-file-path-in-terminal)

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(define-key global-map (kbd "C-c )") 'copy-file-name-to-clipboard)

(when (fboundp 'eww)
  (progn
    (defun xah-rename-eww-hook ()
      "Rename eww browser's buffer so sites open in new page."
      (rename-buffer "eww" t))
    (defun my-eww-mode-hook ()
      (define-key eww-mode-map (kbd "<mouse-8>") 'eww-back-url)
      (define-key eww-mode-map (kbd "<backspace>") 'eww-back-url)
      )
    (add-hook 'eww-mode-hook 'xah-rename-eww-hook 'my-eww-mode-hook)
    ))

(setq tramp-auto-save-directory "~/.emacs.d/savefile")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(provide 'general)
;;; general.el ends here
