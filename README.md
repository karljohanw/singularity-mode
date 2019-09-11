# singularity-mode
A Singularity recipe mode for emacs

``` emacs-lisp
(add-to-list 'load-path "/your/path/to/singularity-mode/")
(require 'singularity-mode)
(add-to-list 'auto-mode-alist '("\\.rec$" . singularity-mode))
(add-to-list 'auto-mode-alist '("Singularity\\(\\.[^\\/]*\\)?$" . singularity-mode))

```
