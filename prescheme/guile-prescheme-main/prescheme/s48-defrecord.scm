;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees
;;;
;;;  scheme48-1.9.2/scheme/big/defrecord.scm
;;;
;;; Syntax for defining record types
;;;
;;; This knows about the implementation of records and creates the various
;;; accessors, mutators, etc. directly instead of calling the procedures
;;; from the record structure.  This is done to allow the optional auto-inlining
;;; optimizer to inline the accessors, mutators, etc.
;;;
;;; LOOPHOLE is used to get a little compile-time type checking (in addition to
;;; the usual complete run-time checking).
;;;
;;; (define-record-type name constructor-fields other-fields)
;;;
;;; Constructor-arguments fields are either <name> or (<name>), the second
;;; indicating a field whose value can be modified.
;;; Other-fields are one of:
;;;  (<name> <expression>) = modifiable field with the given value.
;;;  <name>                = modifiable field with no initial value.
;;;
;;;(define-record-type job
;;;  ((thunk)
;;;   (dynamic-env)
;;;   number
;;;   inferior-lock
;;;   )
;;;  ((on-queue  #f)
;;;   (superior  #f)
;;;   (inferiors '())
;;;   (condition #f)
;;;   ))

(define-module (prescheme s48-defrecord)
  #:use-module ((srfi srfi-9) #:prefix srfi-9:)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme syntax-utils)
  #:export (define-record-type))

(define-syntax define-record-type
  (lambda (x)
    (syntax-case x ()
      ((_ name (arg-defs ...) (other-defs ...))
       (with-syntax ((type-name (syntax-conc 'type/ #'name))
                     (pred-name (syntax-conc #'name '?))
                     (cons-name (syntax-conc '%make- #'name))
                     (maker-name (syntax-conc #'name '-maker))
                     ((arg-names ...) (map (lambda (def)
                                             (syntax-case def ()
                                               ((fname) #'fname)
                                               (fname #'fname)))
                                           #'(arg-defs ...)))
                     ((other-names ...) (map (lambda (def)
                                               (syntax-case def ()
                                                 ((fname _) #'fname)
                                                 (fname #'fname)))
                                             #'(other-defs ...)))
                     ((other-values ...) (map (lambda (def)
                                                (syntax-case def ()
                                                  ((_ value) #'value)
                                                  (_ #'unspecific)))
                                              #'(other-defs ...))))
         (let* ((field-setter? (append (map (lambda (def)
                                              (syntax-case def ()
                                                ((fname) #t)
                                                (_ #f)))
                                            #'(arg-defs ...))
                                       (make-list
                                        (length #'(other-defs ...)) #t)))
                (field-names #'(arg-names ... other-names ...))
                (field-getters (map (lambda (fname)
                                      (syntax-conc #'name '- fname))
                                    field-names))
                (field-setters (map (lambda (fname setter?)
                                      (if setter?
                                          (syntax-conc 'set- #'name '- fname '!)
                                          #f))
                                    field-names field-setter?)))
           #`(begin
               (srfi-9:define-record-type type-name
                 (cons-name arg-names ... other-names ...)
                 pred-name
                 #,@(map (lambda (fname getter setter)
                           (if setter
                               #`(#,fname #,getter #,setter)
                               #`(#,fname #,getter)))
                         field-names field-getters field-setters))
               (define (maker-name arg-names ...)
                 (cons-name arg-names ... other-values ...))
               )))))))
