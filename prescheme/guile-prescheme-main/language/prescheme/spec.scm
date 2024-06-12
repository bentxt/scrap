;;; Copyright 2022 Andrew Whatson

(define-module (language prescheme spec)
  #:use-module (system base language)
  #:use-module (language scheme compile-tree-il)
  #:use-module (language scheme decompile-tree-il))

(define (reader port env)
  (read-syntax port))

(define (default-environment)
  (let ((m (make-module)))
    (module-use! m (resolve-interface '(language prescheme core)))
    m))

(define-language prescheme
  #:title "Pre-Scheme"
  #:reader reader
  #:printer write
  #:compilers   `((tree-il . ,compile-tree-il))
  #:decompilers `((tree-il . ,decompile-tree-il))
  #:evaluator   (lambda (x module) (primitive-eval x))
  #:make-default-environment default-environment)
