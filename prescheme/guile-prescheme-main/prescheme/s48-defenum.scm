;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber
;;;
;;;  scheme48-1.9.2/scheme/rts/defenum.scm
;;;
;;; define-enumeration macro
;;;

(define-module (prescheme s48-defenum)
  #:use-module (prescheme syntax-utils)
  #:export (define-enumeration
            enum
            enumerand->name
            name->enumerand))

(define-syntax define-enumeration
  (lambda (x)
    (syntax-case x ()
      ((_ e-name (e-elems ...))
       (with-syntax ((e-vector (syntax-conc #'e-name '-enumeration))
                     (e-count (syntax-conc #'e-name '-count)))
         (let* ((elements #'(e-elems ...))
                (count (length elements))
                (indexes (iota count)))
           #`(begin
               (define e-vector #(e-elems ...))
               (define e-count #,count)
               (define-syntax e-name
                 (syntax-rules (get e-elems ...)
                   ((_ get) e-vector)
                   #,@(map (lambda (elem ix)
                             #`((_ get #,elem) #,ix))
                           elements indexes)))
               )))))))

(define-syntax components
  (syntax-rules (get)
    ((_ ?type)
     (?type get))))

(define-syntax enum
  (syntax-rules (get)
    ((_ ?type ?enumerand)
     (?type get ?enumerand))))

(define-syntax enumerand->name
  (syntax-rules ()
    ((enumerand->name ?enumerand ?type)
     (vector-ref (components ?type) ?enumerand))))

(define-syntax name->enumerand
  (syntax-rules ()
    ((name->enumerand ?name ?type)
     (lookup-enumerand (components ?type) ?name))))

(define (lookup-enumerand components name)
  (let ((len (vector-length components)))
    (let loop ((i 0))                   ;;vector-posq
      (if (>= i len)
          #f
          (if (eq? name (vector-ref components i))
              i
              (loop (+ i 1)))))))
