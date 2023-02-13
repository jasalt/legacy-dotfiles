;; General customization for programming modes.

(prelude-require-package 'web-beautify)
(prelude-require-package 'emmet-mode)
(prelude-require-package 'pyenv-mode)

;; debugger for python (and others) TODO
(prelude-require-package 'realgud)

;; sql-mode auto indenting does not work correclty without this
(prelude-require-package 'sql-indent)


(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;;;;; PHP Config

;; (flycheck-define-checker my-php
;;   "A PHP syntax checker using the PHP command line interpreter.
;; See URL `http://php.net/manual/en/features.commandline.php'."
;;   :command ("php" "-l" "-d" "error_reporting=E_ALL" "-d" "display_errors=1"
;;             "-d" "log_errors=0" source)
;;   :error-patterns
;;   ((error line-start (or "Parse" "Fatal" "syntax") " error" (any ":" ",") " "
;;           (message) " in " (file-name) " on line " line line-end))
;;   :modes (php-mode php+-mode web-mode))

;; (defun my-setup-php ()
;;   ;; enable web mode
;;   (web-mode)

;;   ;; make these variables local
;;   (make-local-variable 'web-mode-code-indent-offset)
;;   (make-local-variable 'web-mode-markup-indent-offset)
;;   (make-local-variable 'web-mode-css-indent-offset)

;;   ;; set indentation, can set different indentation level for different code type
;;   (setq web-mode-code-indent-offset 4)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-markup-indent-offset 2)

;;   (flycheck-select-checker 'my-php)
;;   (flycheck-mode t)
;;   )

;; (add-to-list 'auto-mode-alist '("\\.php$" . my-setup-php))


(defun my-web-mode-hook ()
  "Hooks for Web mode."
  ;;(local-set-key '[backtab] 'indent-relative)
  ;;   ;;(setq indent-tabs-mode nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  )

(add-hook 'web-mode-hook  'my-web-mode-hook)



(defun my-smartparens-mode-hook ()
  (define-key smartparens-mode-map (kbd "H-n") 'sp-splice-sexp-killing-forward)
  (define-key smartparens-mode-map (kbd "H-p") 'sp-splice-sexp-killing-backward)

  (progn-on "darwin"
            (define-key smartparens-mode-map (kbd "<kp-multiply>")
              'sp-splice-sexp-killing-backward))

  (define-key smartparens-mode-map (kbd "H-f") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "H-b") 'sp-forward-barf-sexp)


  (define-key smartparens-mode-map (kbd "M-<right>") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "M-<left>") 'sp-forward-barf-sexp)
  )

(add-hook 'smartparens-mode-hook 'my-smartparens-mode-hook)

;; (prelude-require-package 'yasnippet)
;; (require 'yasnippet)
;; (define-key yas-minor-mode-map (kbd "<tab>") nil)
;; (define-key yas-minor-mode-map (kbd "TAB") nil)
;; (define-key yas-minor-mode-map (kbd "C-<tab>") 'yas-expand)
;; (yas-global-mode 1)

;; (let ((my-yas-custom-dir (concat dotfiles-folder "emacs/snippets/")))
;;   (setq yas-snippet-dirs (append yas-snippet-dirs (list my-yas-custom-dir))))

(define-key global-map (kbd "<f5>") 'compile)

