;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Mike Sperber
;;;
;;;   scheme48-1.9.2/scheme/rts/low-syntax.scm
;;;
;;; Low-level support for different kinds of syntax transformers
;;;
;;; We just use a vector with a tag in slot 0.  (Can't be a pair,
;;; because syntax transformers may be pairs of transformer and aux
;;; names.)
;;;
;;; 4-argument version of explicit-renaming transformers
;;; (expression name? rename compare)

(define-module (prescheme bcomp transform4)
  #:export (make-explicit-renaming-transformer/4
            explicit-renaming-transformer/4?
            explicit-renaming-transformer/4-proc))

(define (make-explicit-renaming-transformer/4 proc)
  (vector 'explicit-renaming-transformer/4 proc))

(define (explicit-renaming-transformer/4? thing)
  (and (vector? thing)
       (= 2 (vector-length thing))
       (eq? 'explicit-renaming-transformer/4 (vector-ref thing 0))))

(define (explicit-renaming-transformer/4-proc thing)
  (vector-ref thing 1))
