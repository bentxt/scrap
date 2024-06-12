;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Timo Harter
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/c-decl.scm

(define-module (ps-compiler prescheme c-util)
  #:use-module (ps-compiler node node)
  #:use-module (ps-compiler node node-util)
  #:use-module (ps-compiler node variable)
  #:use-module (ps-compiler prescheme spec)
  #:use-module (ps-compiler prescheme type)
  #:use-module (ps-compiler prescheme type-var)
  #:export (*local-vars*
            goto-call?
            final-variable-type))

;;------------------------------------------------------------
;; Collecting local variables.  Each is added to this list when it is first
;; used.

(define *local-vars* '())

;;----------------------------------------------------------------
;; Random utility here for historical reasons.

(define (goto-call? call)
  (and (calls-this-primop? call 'unknown-tail-call)
       (goto-protocol? (literal-value (call-arg call 2)))))

;;----------------------------------------------------------------
;; random type stuff

(define (reference-type node)
  (finalize-variable-type (reference-variable node)))

(define (finalize-variable-type var)
  (let* ((type (finalize-type (variable-type var)))
         (type (if (uvar? type)
                   type/null
                   type)))
    (set-variable-type! var type)
    type))

(define final-variable-type finalize-variable-type)
