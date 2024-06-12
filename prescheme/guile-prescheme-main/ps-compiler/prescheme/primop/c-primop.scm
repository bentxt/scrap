;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/primop/c-primop.scm
;;;
;;; Code generation for primops.

(define-module (ps-compiler prescheme primop c-primop)
  #:use-module (srfi srfi-9)
  #:use-module (ps-compiler node primop)
  #:use-module (ps-compiler prescheme primop primop)
  #:export (simple-c-primop?
            primop-generate-c
            define-c-generator))

(define-record-type :c-primop
  (make-c-primop simple? generate)
  c-primop?
  (simple? c-primop-simple?)
  (generate c-primop-generate))

(define (simple-c-primop? primop)
  (c-primop-simple? (primop-code-data primop)))

(define (primop-generate-c primop call port indent)
  ((c-primop-generate (primop-code-data primop))
   call port indent))

(define-syntax define-c-generator
  (syntax-rules ()
    ((_ id simple? generate)
     (set-primop-code-data!
      (get-prescheme-primop 'id)
      (make-c-primop simple? generate)))))
