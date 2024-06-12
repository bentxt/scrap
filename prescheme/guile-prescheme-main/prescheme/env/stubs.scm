;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber, Robert
;;; Ransom, Marcus Crestani, Sebastian Rheinnecker
;;;
;;;   scheme48-1.9.2/scheme/env/command.scm
;;;   scheme48-1.9.2/scheme/env/pacman.scm
;;;   scheme48-1.9.2/scheme/env/user.scm
;;;
;;; A minimal set of stubs from the Scheme 48 command processor needed for
;;; prescheme compilation.

(define-module (prescheme env stubs)
  #:use-module (prescheme scheme48)
  #:export (config-package))

(define *user-context-initializers* '())

(define user-context
  (let ((ctx #f))
    (lambda ()
      (unless ctx
        (set! ctx (make-user-context)))
      ctx)))

(define (make-user-context)
  (let ((context (make-symbol-table)))
    (for-each (lambda (name+thunk)
                (table-set! context (car name+thunk) ((cdr name+thunk))))
              *user-context-initializers*)
    context))

(define (user-context-accessor name initializer)
  (set! *user-context-initializers*
        (append *user-context-initializers*
                (list (cons name initializer))))
  (lambda ()
    (table-ref (user-context) name)))

(define config-package
  (user-context-accessor 'config-package interaction-environment))
