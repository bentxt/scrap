;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber
;;;
;;;  scheme48-1.9.2/scheme/prescheme/ps-defenum.scm
;;;
;;; DEFINE-ENUMERATION macro hacked to use external (C enumeration) names
;;; instead of integers.
;;;
;;;  (define-external-enumeration bing
;;;    ((foo "BAR")
;;;     baz))
;;;    =>
;;;  (define-syntax bing ...)
;;;  (define bing/foo (make-external-constant 'bing 'foo "BAR"))
;;;  (define bing/baz (make-external-constant 'bing 'baz "BAZ"))
;;;
;;;  (enum bing foo) => bing/foo
;;;

(define-module (prescheme ps-defenum)
  #:use-module (srfi srfi-9)
  #:use-module (prescheme s48-defenum)
  #:use-module (prescheme record-discloser)
  #:use-module (prescheme syntax-utils)
  #:re-export (enum)
  #:export (make-external-constant
            external-constant?
            external-constant-enum-name
            external-constant-name
            external-constant-c-string
            define-external-enumeration))

(define-record-type :external-constant
  (make-external-constant enum-name name c-string)
  external-constant?
  (enum-name external-constant-enum-name)
  (name external-constant-name)
  (c-string external-constant-c-string))

(define-record-discloser :external-constant
  (lambda (external-const)
    (list 'enum
          (external-constant-enum-name external-const)
          (external-constant-name external-const))))

(define (symbol->upcase-string s)
  (list->string (map (lambda (c)
                       (if (char=? c #\-)
                           #\_
                           (char-upcase c)))
                     (string->list (symbol->string s)))))

(define (syntax->upcase-string s)
  (datum->syntax s (symbol->upcase-string (syntax->datum s))))

(define-syntax define-external-enumeration
  (lambda (x)
    (syntax-case x ()
      ((_ e-name (elem-defs ...))
       (with-syntax (((elems ...) (map (lambda (def)
                                         (syntax-case def ()
                                           ((elem c-name) #'elem)
                                           (elem #'elem)))
                                       #'(elem-defs ...)))
                     ((c-names ...) (map (lambda (def)
                                           (syntax-case def ()
                                             ((elem c-name) #'c-name)
                                             (elem (syntax->upcase-string #'elem))))
                                         #'(elem-defs ...)))
                     (e-count (syntax-conc #'e-name '-count)))
         (let* ((elements #'(elems ...))
                (c-names #'(c-names ...))
                (e-symbol (syntax->datum #'e-name))
                (var-names (map (lambda (elem)
                                  (syntax-conc e-symbol '/ elem))
                                elements)))
           #`(begin
               (define-syntax e-name
                 (syntax-rules (get elems ...)
                   #,@(map (lambda (elem var-name)
                             #`((_ get #,elem) #,var-name))
                           elements var-names)))
               (define e-count #,(length elements))
               #,@(map (lambda (elem c-name var-name)
                         #`(define #,var-name
                             (make-external-constant 'e-name '#,elem #,c-name)))
                       elements c-names var-names)
               )))))))
