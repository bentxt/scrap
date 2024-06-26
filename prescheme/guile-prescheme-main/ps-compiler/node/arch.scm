;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/node/arch.scm
;;;
;;; These are all of the primitives that are known to the compiler.
;;;
;;; The enumeration is needed by the expander for LET-NODES so it ends up
;;; being loaded into two separate packages.

(define-module (ps-compiler node arch)
  #:use-module (prescheme s48-defenum)
  #:re-export (enum name->enumerand enumerand->name)
  #:export (primop-enum
            primop-enum-count))

(define-enumeration primop-enum
  (
   ;; Nontrivial Primops
   call              ;; see below
   tail-call
   return
   jump
   throw

   unknown-call
   unknown-tail-call
   unknown-return

   dispatch          ;; (dispatch <cont1> ... <contN> <exp>)
   let               ;; (let <lambda-node> . <args>)
   letrec1           ;; (letrec1 (lambda (x v1 v2 ...)
   letrec2           ;;            (letrec2 <cont> x <lambda1> <lambda2> ...)))

   cell-set!
   global-set!

   undefined-effect  ;; (undefined-effect . <maybe-args>)

   ;; Trivial Primops
   make-cell
   cell-ref
   global-ref

   ;; Environment stuff, these are both trivial
   closure
   env-ref
   ))
