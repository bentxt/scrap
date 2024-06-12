;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/expand.scm
;;;
;;; Expanding using the Scheme 48 expander.

(define-module (ps-compiler prescheme expand)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme bcomp node)
  #:use-module (prescheme bcomp binding)
  #:use-module (prescheme bcomp package)
  #:use-module (prescheme bcomp scan-package)
  #:use-module (prescheme bcomp syntax)
  #:use-module (prescheme locations)
  #:use-module (ps-compiler node variable)
  #:use-module (ps-compiler util util)
  #:use-module (ps-compiler prescheme eval)
  #:use-module (ps-compiler prescheme primitive)
  #:export (scan-packages))

(define (scan-packages packages)
  (let ((definitions
          (fold (lambda (package definitions)
                  (let ((cenv (package->environment package)))
                    (fold (lambda (form definitions)
                            (let ((node (expand-form form cenv)))
                              (cond ((define-node? node)
                                     (cons (eval-define (expand node cenv)
                                                        cenv)
                                           definitions))
                                    (else
                                     (eval-node (expand node cenv)
                                                global-ref
                                                global-set!
                                                eval-primitive)
                                     definitions))))
                          (call-with-values
                           (lambda ()
                             (package-source package))
                           (lambda (files.forms usual-transforms primitives?)
                             (scan-forms (apply append (map cdr files.forms))
                                         cenv)))
                          definitions)))
                packages
                '())))
    (reverse (map (lambda (var)
                    (let ((value (variable-flag var)))
                      (set-variable-flag! var #f)
                      (cons var value)))
                  definitions))))

(define define-node? (node-predicate 'define))

(define (eval-define node cenv)
  (let* ((form (node-form node))
         (value (eval-node (caddr form)
                           global-ref
                           global-set!
                           eval-primitive))
         (lhs (cadr form)))
    (global-set! lhs value)
    (name->variable-or-value lhs)))

(define (global-ref name)
  (let ((thing (name->variable-or-value name)))
    (if (variable? thing)
        (variable-flag thing)
        thing)))

(define (global-set! name value)
  (let ((thing (name->variable-or-value name)))
    (if (primitive? thing)
        (bug "trying to set the value of primitive ~S" thing)
        (set-variable-flag! thing value))))

(define (name->variable-or-value name)
  (let ((binding (node-ref name 'binding)))
    (if (binding? binding)
        (let ((value (binding-place binding))
              (static (binding-static binding)))
          (cond ((primitive? static)
                 static)
                ((variable? value)
                 value)
                ((and (location? value)
                      (constant? (contents value)))
                 (contents value))
                (else
                 (bug "global binding is not a variable, primitive or constant ~S" name))))
        (user-error "unbound variable ~S" (node-form name)))))
