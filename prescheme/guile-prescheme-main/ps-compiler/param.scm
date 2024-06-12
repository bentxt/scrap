;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/param.scm
;;;
;;; Parameterizing the compiler.

(define-module (ps-compiler param)
  #:export (lookup-primop
            lookup-imported-variable

            type/unknown
            type-eq?

            lambda-node-type

            true-value
            false-value

            determine-lambda-protocol
            determine-continuation-protocol

            set-compiler-parameter!))

(define lookup-primop 'unset-compiler-parameter)
(define lookup-imported-variable 'unset-compiler-parameter)

(define type/unknown 'unset-compiler-parameter)
(define type-eq? 'unset-compiler-parameter)

(define lambda-node-type 'unset-compiler-parameter)

(define true-value  'unset-compiler-parameter)
(define false-value 'unset-compiler-parameter)

(define determine-lambda-protocol       'unset-compiler-parameter)
(define determine-continuation-protocol 'unset-compiler-parameter)

(define (set-compiler-parameter! name value)
  (case name
    ((lookup-primop)
     (set! lookup-primop value))
    ((lookup-imported-variable)
     (set! lookup-imported-variable value))
    ((type/unknown)
     (set! type/unknown value))
    ((type-eq?)
     (set! type-eq? value))
    ((lambda-node-type)
     (set! lambda-node-type value))
    ((true-value)
     (set! true-value value))
    ((false-value)
     (set! false-value value))
    ((determine-lambda-protocol)
     (set! determine-lambda-protocol value))
    ((determine-continuation-protocol)
     (set! determine-continuation-protocol value))
    (else
     (error "unknown compiler parameter ~S ~S" name value))))
