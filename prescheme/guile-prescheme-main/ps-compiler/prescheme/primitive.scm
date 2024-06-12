;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/primitive.scm
;;;
;;; Eval'ing and type-checking code for primitives.

(define-module (ps-compiler prescheme primitive)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme s48-defrecord)
  #:use-module (prescheme record-discloser)
  #:use-module (ps-compiler util util)
  #:export (primitive?
            make-primitive
            eval-primitive
            primitive-id
            primitive-source
            primitive-expander
            primitive-expands-in-place?
            primitive-inference-rule))

(define-record-type primitive
  (id                ;; for debugging & making tables
   arg-predicates    ;; predicates for checking argument types
   eval              ;; evaluation function
   source            ;; close-compiled source (if any)
   expander          ;; convert call to one using primops
   expands-in-place? ;; does the expander expand the definition in-line?
   inference-rule    ;; type inference rule
   )
  ())

(define make-primitive primitive-maker)

(define-record-discloser type/primitive
  (lambda (primitive)
    (list 'primitive (primitive-id primitive))))

(define (eval-primitive primitive args)
  (cond ((not (primitive? primitive))
         (user-error "error while evaluating: ~A is not a procedure" primitive))
        ((args-okay? args (primitive-arg-predicates primitive))
         (apply (primitive-eval primitive) args))
        (else
         (user-error "error while evaluating: type error ~A"
                     (cons (primitive-id primitive) args)))))

;; PREDICATES is a (possibly improper) list of predicates that should match
;; ARGS.

(define (args-okay? args predicates)
  (cond ((atom? predicates)
         (if predicates
             (every? predicates args)
             #t))
        ((null? args)
         #f)
        ((car predicates)
         (and ((car predicates) (car args))
              (args-okay? (cdr args) (cdr predicates))))
        (else
         (args-okay? (cdr args) (cdr predicates)))))
