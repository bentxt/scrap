;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Mike Sperber, Marcus Crestani
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/package-defs.scm

(define-module (ps-compiler prescheme external-value)
  #:use-module (srfi srfi-9)
  #:export (external-value?
            make-external-value
            external-value-type
            external-value-string))

(define-record-type :external-value
      (make-external-value string type)
      external-value?
      (string external-value-string)
      (type external-value-type))
