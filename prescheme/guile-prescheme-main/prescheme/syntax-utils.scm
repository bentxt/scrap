;;; Copyright 2022 Andrew Whatson

(define-module (prescheme syntax-utils)
  #:use-module (srfi srfi-1)
  #:use-module (system syntax)
  #:export (syntax-conc))

(define (syntax-conc . things)
  (let ((sob (find syntax? things))
        (syms (map (lambda (thing)
                     (if (syntax? thing)
                         (syntax->datum thing)
                         thing))
                   things)))
    (datum->syntax sob (apply symbol-append syms))))
