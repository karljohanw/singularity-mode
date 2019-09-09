(require 'sh-script)

(defcustom singularity-indent 2
  "User definable indentation"
  :group 'singularity
  :type '(integer))

(defun singularity-indent-line ()
  "Simple indenting function for singularity recepies."
  (interactive)
  (beginning-of-line)
  (if (bobp) (indent-line-to 0) ;indent beginning of file
    (let ((not-indented t) cur-indent (is-empty-line (looking-at "^[ \t]*$"))) ;set up vars
      (if (looking-at "^[ \t]*%") ;this is straight forward
	  (setq cur-indent 0)
	(save-excursion
	  (forward-line -1)
	  (if (looking-at "^[ \t]*.*\\\\[ \t]*")
	      (setq cur-indent (* singularity-indent 2))
	    (if (and is-empty-line (looking-at "^[ \t]*$"))
		(setq cur-indent 0)
	      (while not-indented
		(if (looking-at "^[ \t]*%")
		    (progn
		      (setq not-indented nil)
		      (setq cur-indent singularity-indent))
		  (if (bobp) (setq not-indented nil))
		  )
		(forward-line -1)
		)
	      )
	    )
	  )
	)
      (if cur-indent (indent-line-to cur-indent) (indent-line-to 0))
      )))

;;;###autoload
(define-derived-mode singularity-mode shell-script-mode "Singularity Recipe mode"
  "Major mode for editing Singularity Recipes."

  (defvar singularity-font-lock-keywords
    `(
      (,(regexp-opt '("%help" "%setup" "%files" "%labels" "%environment" "%post" "%test" "%runscript" "%appinstall" "%applabels" "%appfiles" "%appenv" "%apptest" "%apphelp" "%apprun") 'symbols) . font-lock-type-face)
      (,(regexp-opt '("BootStrap:" "Bootstrap:" "From:" "IncludeCmd:" "MirrorURL:" "UpdateURL:" "OSVersion:" "Include:" "Library:" "Registry:" "Namespace:" "Stage:" "Product:" "User:" "RegCode:" "Regcode:" "ProductPGP:" "RegisterURL:" "Modules:" "OtherURL:") 'symbols) . font-lock-keyword-face)
      ,@(sh-font-lock-keywords)
      ,@(sh-font-lock-keywords-2)
      ,@(sh-font-lock-keywords-1))
    "Default `font-lock-keywords' for `singularity mode'.")
  
  (setq font-lock-defaults `(singularity-font-lock-keywords ,@(cdr font-lock-defaults)))
  (set (make-local-variable 'indent-line-function) 'singularity-indent-line)
  (define-key sh-mode-map [menu-bar sh-script] nil)
)
(provide 'singularity-mode)
