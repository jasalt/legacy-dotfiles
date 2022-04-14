;; Entry point for custom Emacs configuration.
;; See README for installation guide
;; This file is symlinked into ~/.emacs.d/personal/init.el
(if (string-equal system-type "windows-nt")
    (setenv "HOME" "c:/Users/Admin/")
    )



(setq dotfiles-folder "~/dotfiles/")

; Fix prelude package problem with undo-tree being unsigned
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq ad-redefinition-action 'accept)





(let ((conf-files
       '(
         ;"emacs/modes/acme-search.el"
 ;        "emacs/modes/google-translate-mode.el"
         "emacs/general.el"
         "emacs/programming.el"
   ;;      
         ;"lang/web/web.el"
         ;"lang/python/python.el"
         ;;"lang/clojure/clojure.el"
)))
  (dolist (entry conf-files) (load (concat dotfiles-folder entry))))

;;(load "~/.maildir/.mu4e.el")

(defvar org-folder)
(setq org-folder "~/notes/")

;; check if org-folder exists, skip this file if it doesn't
(if (file-directory-p org-folder)
    (load "~/dotfiles/emacs/orgmode.el"))
