;; Configuration for writing and arranging text

(prelude-require-package 'htmlize)

;; (prelude-require-package 'ledger-mode)
;; setup files ending in “.ledger” to open in ledger-mode
;; (add-to-list 'auto-mode-alist '("\\.ledger\\'" . ledger-mode))

(prelude-require-package 'org-download)
(require 'org-download)
(setq-default org-download-image-dir "~/notes/pics/")
(setq org-image-actual-width 400)

;;(prelude-require-package 'writeroom-mode) ;; does a bit too much

(prelude-require-package 'olivetti)
(add-hook 'olivetti-mode-hook
	  (lambda ()
	    (if olivetti-mode
		(progn
		  (blink-cursor-mode 0)  ; turn off blinky cursor
		  (fringe-mode 0)  ; hide fringes
		  (setq-local inhibit-message t))  ; don't distract
	      (progn
		(blink-cursor-mode t)
		(fringe-mode nil)
		(setq-local inhibit-message t)))))


;; https://www.languagetool.org
;; (prelude-require-package 'langtool)
;; (setq langtool-language-tool-jar
;;       "/vendor/languagetool/languagetool-commandline.jar")

;; (defun langtool-autoshow-detail-popup (overlays)
;;   (when (require 'popup nil t)
;;     ;; Do not interrupt current popup
;;     (unless (or popup-instances
;;                 ;; suppress popup after type `C-g` .
;;                 (memq last-command '(keyboard-quit)))
;;       (let ((msg (langtool-details-error-message overlays)))
;;         (popup-tip msg)))))
;; (setq langtool-autoshow-message-function
;;       'langtool-autoshow-detail-popup)

(require 'org)
;; https://stackoverflow.com/questions/12432093/get-rid-of-reference-to-free-variable-byte-compilation-warnings

(setq org-startup-folded t)

(require 'find-lisp)
;; Add projects folder to agenda files
(setq org-agenda-files (let ((default-directory (concat org-folder "projects")))
                         (file-expand-wildcards "?*.org" t)))


;; Add some individual files to agenda files
(add-to-list 'org-agenda-files (expand-file-name
                                (concat org-folder "todo.org")))
(add-to-list 'org-agenda-files (expand-file-name
                                (concat org-folder "future.org")))
;; (add-to-list 'org-agenda-files (expand-file-name
;;                                 (concat org-folder "cron.org")))
;; (add-to-list 'org-agenda-files (expand-file-name
;;                                 (concat org-folder "interesting.org")))
(add-to-list 'org-agenda-files (expand-file-name
                                (concat org-folder "inbox.org")))
(add-to-list 'org-agenda-files (expand-file-name
                                "~/.ext-calendar.org"))

;; HACK fix terminal org-mode RET-j binding
(define-key org-mode-map (kbd "C-j") 'org-insert-heading-respect-content)

(global-set-key (kbd "C-c 1")
                (lambda ()
                  (interactive)
                  (find-file (concat org-folder "inbox.org"))))
(global-set-key (kbd "C-c 2")
                (lambda ()
                  (interactive)
                  (find-file (concat org-folder "todo.org"))))
(global-set-key (kbd "C-c S-2")
                (lambda ()
                  (interactive)
                  (find-file (concat org-folder "interesting.org"))))
(global-set-key (kbd "C-c 3")
                (lambda ()
                  (interactive)
                  (find-file (concat org-folder "/projects/as.org"))))
                ;; (lambda ()
                ;;   (interactive)
                ;;   (find-file (concat org-folder "/projects"))))

(global-set-key (kbd "C-c 4")
                (lambda ()
                  (interactive)
                  (dired "~/dev/")))
(global-set-key (kbd "C-c 5")
                (lambda ()
                  (interactive)
                  (find-file dotfiles-folder)))

;; Global org-capture / agenda
(global-set-key (kbd "H-c") 'org-capture)
(global-set-key (kbd "H-a") 'org-agenda)

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame."
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

;; (defun capture-report-data-file (path)
;;   )

(setq org-log-done 'nil)

(setq org-capture-templates
      '(
        ;; ("p" "Post skeleton" entry (file (capture-report-date-file
        ;;                                           "~/dev/landing/blog/src/content/posts/"))
        ;;          "* Title :tags:
        ;; :PROPERTIES:
        ;; :date: %t
        ;; :slug:
        ;; :summary:
        ;; Body")

        ("i" "Save to Inbox" entry
         (file (lambda () (concat org-folder "inbox.org")) "inbox") "* %?\n  %i\n")
        ("t" "TODO Item" entry
         (file+headline (lambda () (concat org-folder "gtd.org")) "Tasks") "* TODO %?\n  %i\n")
        ("a" "Appointment or other scheduled item" entry
         (file+headline (lambda () (concat org-folder "gtd.org")) "Scheduled") "* APPT %?\n  %i\n")
        ("j" "Journal entry" entry (file+datetree (lambda () (concat org-folder "texts/meta/notetoself.org")))
         "* %?\nEntered on %U\n  %i\n")
        ("d" "Dream entry" entry (file+datetree (lambda () (concat org-folder "texts/meta/dream.org")))
         "* %?\nEntered on %U\n  %i\n")
        ("r" "Save Recommendation" entry (file+headline (lambda () (concat org-folder "inbox.org")) "Recommendations") "* %?\n  %i\n")
        ("p" "New project file" entry
         (file (lambda () (concat org-folder "projects/"
                       (let ((prompt (read-string "New project [filename].org: ")))
                         (concat prompt ".org"))))) "* %?\n  %i\n")))

(setq org-agenda-skip-scheduled-if-done 'nil)

(setq org-todo-keywords
      '((sequence "TODO(t)" "APPT(a)" "WAIT(w)" "|" "CANCELLED(c)" "DONE(d)")))

(setq org-agenda-custom-commands
      '(
        ("z" "Today"
         ((agenda "" ((org-agenda-ndays 1)))
          (tags-todo "+PRIORITY=\"A\"")
          (todo "TODO")
          ;;(todo "WAIT"))
          ;;(tags-todo "computer|office|phoned")
          ;;(tags "project+CATEGORY=\"elephants\"")
          ;;(tags "review" ((org-agenda-files '("~/org/circuspeanuts.org"))))
          (org-agenda-compact-blocks t)))
        )
      )

(setq system-time-locale "C")

(setq org-agenda-custom-commands
      '(        ;; other commands go here
        ;; ("w" "Week"
        ;;  ((agenda "" ((org-agenda-ndays 7))) ;; review upcoming deadlines and appointments
        ;;   ;; type "l" in the agenda to review logged items

        ;;   (todo "TODO") ;; review all projects (assuming you use todo keywords to designate projects)
        ;;   (todo "APPT") ;; review someday/maybe items
        ;;   (todo "WAIT")
        ;;   (stuck "")))

        ("d" "Day"
         ((agenda "" ((org-agenda-ndays 1))) ;; review upcoming deadlines and appointments
          (tags-todo "+PRIORITY=\"A\"")
          ;;(todo "TODO") ;; review all projects (assuming you use todo keywords to designate projects)
          ;;(todo "MAYBE") ;; review someday/maybe items
          ;;(todo "WAITING")
          )) ;; review waiting items

        ("c" "Calendar 2 Weeks" agenda ""
         ((org-agenda-ndays 14)                          ;; [1]
          (org-agenda-start-on-weekday 1)               ;; [2]
          (org-agenda-time-grid nil)
          (org-agenda-repeating-timestamp-show-all t)   ;; [3]
          ))
        ))

(setq org-use-fast-todo-selection t)
(setq org-use-fast-tag-selection t)

;;(setq org-catch-invisible-edits 'smart)
(setq org-catch-invisible-edits 'show)
(setq org-ctrl-k-protect-subtree t)

;; Add syntax highlight to src blocks
(setq org-src-fontify-natively t)

;; Refiling TODO
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps t)


;;; Rewrite this here to disable indicator cap


(defun own-org-mode-hook ()
  "Modify keymaps and settings used by `org-mode'."
  ;; (fringe-mode 0)
  
  (visual-line-mode 1)
  (org-indent-mode 1)
  (company-mode 0)
  (flycheck-mode 0)  ;; prelude programming modes use this global mode
  (electric-pair-mode 1)
  ;;(indent-guide-mode -1)
  ;;(whitespace-mode -1)

  ;; Workaround some smartparens-mode keybindings
  ;;(smartparens-mode -1)
  ;;(autopair-mode)

  ;;(local-set-key (kbd "<C-M-return>") '(org-insert-heading 0 0 nil))

  ;; Avoid arrow keys at all costs
  (local-set-key (kbd "H-N") 'org-move-subtree-up) ; mac workaround
  (local-set-key (kbd "H-p") 'org-move-subtree-up)
  (local-set-key (kbd "H-n") 'org-move-subtree-down)
  (local-set-key (kbd "s-p") 'org-move-subtree-up)
  (local-set-key (kbd "s-n") 'org-move-subtree-down)

  (local-set-key (kbd "M-n") 'org-shiftright)
  (local-set-key (kbd "M-p") 'org-shiftleft)

  (global-unset-key (kbd "C-M-f"))
  (global-unset-key (kbd "C-M-b"))

  (local-set-key (kbd "C-M-f") 'org-shiftmetaright)
  (local-set-key (kbd "C-M-b") 'org-shiftmetaleft)

  (local-set-key (kbd "H-f") 'org-metaright)
  (local-set-key (kbd "H-b") 'org-metaleft)
  )

(add-hook 'org-mode-hook 'own-org-mode-hook)


(add-hook 'org-agenda-mode-hook
          (lambda ()
            (progn
              (define-key org-agenda-mode-map (kbd "<f5>") 'sync-ext-agenda)
              (define-key org-agenda-mode-map (kbd "<f6>") 'org-icalendar-combine-agenda-files)
              (setq org-icalendar-combined-agenda-file "~/Dropbox/Public/org.ics")
              (setq org-icalendar-use-scheduled '(event-if-not-todo event-if-todo)))))

;; (defun sync-ext-agenda ()
;;   (interactive)
;;   (princ "Start syncing external calendar items. Rebuild agenda afterwards.")
;;   (start-process "cal-sync" "foo" (concat dotfiles-folder "emacs/org-ext-calendar/importer.py"))
;;   ;; TODO watch for process completion and refresh agenda buffer accordingly
;;   ;; TODO portability problems
;;   )

;; (sync-ext-agenda)

;; Create filename with datestamp
(defun capture-report-date-file (path)
  (let ((name (read-string "Filename: ")))
    (expand-file-name (format "%s_%s.org"
                              (format-time-string "%Y-%m")
                              name) path)))

;; Drag and drop
;; http://kitchingroup.cheme.cmu.edu/blog/2015/07/10/Drag-images-and-files-onto-org-mode-and-insert-a-link-to-them/
(defun my-dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
         (type (car payload))
         (fname (cadr payload))
         (img-regexp "\\(png\\|jp[e]?g\\)\\>"))
    (cond
     ;; insert image link
     ((and  (eq 'drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; insert image link with caption
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert "#+ATTR_ORG: :width 300\n")
      (insert (concat  "#+CAPTION: " (read-input "Caption: ") "\n"))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; C-drag-n-drop to open a file
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type))
      (find-file fname))
     ((and (eq 'M-drag-n-drop (car event))
           (eq 'file type))
      (insert (format "[[attachfile:%s]]" fname)))
     ;; regular drag and drop on file
     ((eq 'file type)
      (insert (format "[[%s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s" payload)))))

(define-key org-mode-map (kbd "<drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<M-drag-n-drop>") 'my-dnd-func)

;;http://orgmode.org/manual/Template-elements.html
;; Use link to do a quick grep for keyword
;; Eg TODO's in codebase
(org-add-link-type
 "grep" 'endless/follow-grep-link)

(defun endless/follow-grep-link (regexp)
  "Run `rgrep' with REGEXP as argument."
  (grep-compute-defaults)
  (rgrep regexp "*" (expand-file-name "./")))

;; Export customization
(setq org-odt-preferred-output-format "rtf")


;;; Calendar config
;; Week starts on monday
(setq calendar-week-start-day 1)
;; Add week numbers to calendar
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
                    :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'calendar-iso-week-face))
