;; # Copyright (C) 2002 by Monty Taylor
;; # Translate ply files into LaTeX.

;; #     This program is free software; you can redistribute it and/or modify
;; #     it under the terms of the GNU General Public License as published by
;; #     the Free Software Foundation; either version 2 of the License, or
;; #     (at your option) any later version.

;; #     This program is distributed in the hope that it will be useful,
;; #     but WITHOUT ANY WARRANTY; without even the implied warranty of
;; #     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; #     GNU General Public License for more details.

;; #     You should have received a copy of the GNU General Public License
;; #     along with this program; if not, write to the Free Software
;; #     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

;; Create mode-specific tables.
(defvar play-mode-syntax-table nil
  "Syntax table used while in play mode.")

(if play-mode-syntax-table
    () 
  (setq play-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?[ "<" play-mode-syntax-table)
                       (modify-syntax-entry ?] ">" play-mode-syntax-table)
  )

(defun play-translate-file ()
  "Run the current file through plytrans and latex"
  (interactive)
  (and (buffer-modified-p) 
       (and (y-or-n-p (concat "Save " (buffer-file-name) " first ?"))
            (save-buffer)))
  (call-process "plywood" nil "*plywood-out*" nil (buffer-file-name))
)

(defun play-view-pdf ()
  "View the pdf related to the current file."
  (interactive)
  (play-translate-file)
  (start-process "xpdf" "*plywood-out*" "xpdf" (concat (file-name-sans-extension (buffer-file-name)) ".pdf") 
))


(defvar play-font-lock-keywords
  (let ((kw1 (mapconcat 'identity
                        '("play" "scene" "author" "act" "title" "lyrics?" "lines?" "newact" "newscene" "characters" "[Ss]etting" "[Aa]t [Rr]ise" "song")
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
  
(defun new-play ()
  (interactive) 
  (save-buffer))

(define-key menu-bar-file-menu [new-play]
  '("New Play" . new-play))

;;(defvar menu-bar-play-menu (make-sparse-keymap "Play"))
;; (define-key menu-bar-play-menu [play-translate-file]
;;   '("Translate Play" . play-translate-file))
;; (define-key menu-bar-menu [play]
;;   (cons "Play" menu-bar-play-menu))

(defvar play-mode-map (make-sparse-keymap))
(define-key play-mode-map [menu-bar play]
  (cons "Play" (make-sparse-keymap "Play")))

;; Define specific subcommands in this menu.
(define-key play-mode-map
  [menu-bar play translate-file]
  '("Translate play" . play-translate-file))
(define-key play-mode-map
  [menu-bar play view-pdf]
  '("Preview play" . play-view-pdf))
(defun play-mode ()
    "Major mode for editing plays."
    (interactive)
    (kill-all-local-variables)
    (use-local-map play-mode-map)
    (local-set-key "\C-c\C-c" 'play-translate-file)
    (local-set-key "\C-c\C-v" 'play-view-pdf)
    (make-local-variable 'play-translate-file)
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
