;; Create mode-specific tables.
(defvar play-mode-syntax-table nil
  "Syntax table used while in play mode.")

(if play-mode-syntax-table
    () 
  (setq play-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?[ "<" play-mode-syntax-table)
                       (modify-syntax-entry ?] ">" play-mode-syntax-table)
  )
(defvar play-font-lock-keywords
  (let ((kw1 (mapconcat 'identity
                        '("play" "scene" "author" "act" "title")
                        "\\|"))
        (kw2 (mapconcat 'identity
                        '("newact" "newscene")
                        "\\|")))

    (list
     ;; keywords
     (cons (concat "\\b\\(" kw1 "\\):") 1)
     ;; block introducing keywords with immediately following colons.
     ;; Yes "except" is in both lists.
     (cons (concat "\\\\\\(" kw2 "\\)") 1)
     ;; `as' but only in "import foo as bar"
      ; '("[ \t]*\\(\\bfrom\\b.*\\)?\\bimport\\b.*\\b\\(as\\)\\b" . 2)
     ;; classes
                     ; '("\\bclass[ \t]+\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)"
                                        ;   1 font-lock-type-face)
     ;; functions
     '("^[ \t]*\\([a-zA-Z_]+[a-zA-Z0-9_ ]*\\)[ \t]*="
       1 font-lock-function-name-face)
     ))
    "Additional expressions to highlight in Play mode.")
  (put 'play-mode 'font-lock-defaults '(play-font-lock-keywords))
  
  (defun play-mode ()
    "Major mode for editing plays."
    (interactive)
    (kill-all-local-variables)
    (make-local-variable 'font-lock-defaults)
  (make-local-variable 'paragraph-separate)
  (make-local-variable 'paragraph-start)
  (make-local-variable 'require-final-newline)
;  (make-local-variable 'comment-start)
;  (make-local-variable 'comment-end)
  (make-local-variable 'comment-column)
  (make-local-variable 'comment-indent-function)
  (make-local-variable 'indent-region-function)
  (make-local-variable 'indent-line-function)
;  (make-local-variable 'block-comment-start)
;  (make-local-variable 'block-comment-end)
;  (make-local-variable 'comment-end-skip)
;  (make-local-variable 'comment-start-skip)
  (make-local-variable 'add-log-current-defun-function)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (set-syntax-table play-mode-syntax-table)
  (setq major-mode              'play-mode
        mode-name               "Play"
        paragraph-separate      "\n\n"
        require-final-newline   t
        font-lock-defaults '(play-font-lock-keywords)
 ;       comment-start           "["
        comment-start-skip           "\\[\\s*"
 ;       comment-end-skip " *]"
 ;       comment-end             "]"
 ;       block-comment-start "["
 ;       block-comment-end "]"
        comment-column          40
        )
  )