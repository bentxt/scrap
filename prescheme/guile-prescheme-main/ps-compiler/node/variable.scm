;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/node/node.scm
;;;
;;; This file contains the definitions of the node tree data structure.

(define-module (ps-compiler node variable)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme s48-defrecord)
  #:use-module (prescheme record-discloser)
  #:use-module (ps-compiler node node)
  #:use-module (ps-compiler util util)
  #:replace (variable? make-variable)
  #:export (global-variable? make-global-variable
            variable-name set-variable-name!
            variable-id
            variable-type   set-variable-type!
            variable-binder set-variable-binder!
            variable-refs   set-variable-refs!
            variable-flag   set-variable-flag!
            variable-flags  set-variable-flags!
            variable-generate set-variable-generate!
            new-variable-id
            erase-variable
            reset-node-id node-hash node-unhash
            variable-index copy-variable used? unused?
            variable-flag-accessor variable-flag-setter variable-flag-remover
            variable-known-value
            add-variable-known-value!
            remove-variable-known-value!
            variable-simplifier
            add-variable-simplifier!
            remove-variable-simplifier!
            note-known-global-lambda!
            variable-known-lambda))

;;;---------------------------------------------------------------------------
;;; Records to represent variables.

(define-record-type variable
  ((name)        ;; Source code name for variable (used for debugging only)
   (id)          ;; Unique numeric identifier     (used for debugging only)
   (type)        ;; Type for variable's value
   )
  (binder        ;; LAMBDA node which binds this variable
   (refs '())    ;; List of leaf nodes n for which (REFERENCE-VARIABLE n) = var.
   (flag #f)     ;; Useful slot, used by shapes, COPY-NODE, NODE->VECTOR, etc.
                 ;; all users must leave this is #F
   (flags '())   ;; For various annotations, e.g. IGNORABLE
   (generate #f) ;; For whatever code generation wants
   ))

(define-record-discloser type/variable
  (lambda (var)
    (node-hash var)
    (list 'variable (variable-name var) (variable-id var))))

(define (make-variable name type)
  (variable-maker name (new-variable-id) type))

(define (make-global-variable name type)
  (let ((var (make-variable name type)))
    (set-variable-binder! var #f)
    var))

(define (global-variable? var)
  (not (variable-binder var)))

;; Every variable has a unique numeric identifier that is used for printing.

(define *variable-id* 0)

(define (new-variable-id)
  (let ((id *variable-id*))
    (set! *variable-id* (+ 1 *variable-id*))
    id))

(define (erase-variable var)
  (cond ((eq? (variable-id var) '<erased>)
         (bug "variable ~S already erased" var))
        (else
         (set-variable-id! var '<erased>))))

(define *node-hash-table* #f)

(define (reset-node-id)
  (set! *variable-id* 0)
  (set! *node-hash-table* (make-table)))

(define (node-hash var-or-lambda)
  (let ((id (if (variable? var-or-lambda)
                (variable-id var-or-lambda)
                (lambda-id var-or-lambda))))
    (table-set! *node-hash-table* id var-or-lambda)))

(define (node-unhash n)
  (table-ref *node-hash-table* n))

;; The index of VAR in the variables bound by its binder.

(define (variable-index var)
  (let ((binder (variable-binder var)))
    (if (not binder)
        (bug "VARIABLE-INDEX called on global variable ~S" var)
        (do ((i 0 (+ i 1))
             (vs (lambda-variables binder) (cdr vs)))
            ((eq? (car vs) var)
             i)))))

;; Copy an old variable.

(define (copy-variable old)
  (let ((var (make-variable (variable-name old) (variable-type old))))
    (set-variable-flags! var (variable-flags old))
    var))

;; An unused variable is either #F or a variable with no references.

(define (used? var)
  (and var
       (not (null? (variable-refs var)))))

(define (unused? var)
  (not (used? var)))

;; known values for top-level variables

(define (variable-flag-accessor flag)
  (lambda (var)
    (let ((p (flag-assq flag (variable-flags var))))
      (if p (cdr p) #f))))

(define (variable-flag-setter flag)
  (lambda (var value)
    (set-variable-flags! var
                         (cons (cons flag value)
                               (variable-flags var)))))

(define (variable-flag-remover flag)
  (lambda (var)
    (set-variable-flags! var (filter (lambda (x)
                                       (or (not (pair? x))
                                           (not (eq? (car x) flag))))
                                     (variable-flags var)))))

(define variable-known-value (variable-flag-accessor 'known-value))
(define add-variable-known-value! (variable-flag-setter 'known-value))
(define remove-variable-known-value! (variable-flag-remover 'known-value))

(define variable-simplifier (variable-flag-accessor 'simplifier))
(define add-variable-simplifier! (variable-flag-setter 'simplifier))
(define remove-variable-simplifier! (variable-flag-remover 'simplifier))

(define variable-known-lambda (variable-flag-accessor 'known-lambda))
(define note-known-global-lambda! (variable-flag-setter 'known-lambda))
