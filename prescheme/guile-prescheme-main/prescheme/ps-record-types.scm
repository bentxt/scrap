;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber, Marcus Crestani, David Frese
;;;
;;;   scheme48-1.9.2/scheme/prescheme/package-defs.scm

(define-module (prescheme ps-record-types)
  #:use-module ((srfi srfi-9) #:prefix srfi-9:)
  #:export (define-record-type))

(define-syntax define-record-type
  (syntax-rules ()
    ((define-record-type name type-name
       constructor
       (field type more ...) ...)
     (srfi-9:define-record-type type-name
       constructor
       (field more ...) ...))))
