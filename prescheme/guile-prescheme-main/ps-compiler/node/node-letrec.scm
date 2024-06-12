;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Mike Sperber
;;;
;;;   scheme48-1.9.2/ps-compiler/node/node-util.scm
;;;
;;; This file contains miscellaneous utilities for accessing and modifying the
;;; node tree.
;;;

(define-module (ps-compiler node node-letrec)
  #:use-module (prescheme scheme48)
  #:use-module (ps-compiler node let-nodes)
  #:use-module (ps-compiler node node)
  #:use-module (ps-compiler node node-util)
  #:use-module (ps-compiler node primop)
  #:use-module (ps-compiler node variable)
  #:export (put-in-letrec make-letrec))

;;-------------------------------------------------------------------------------
;; Bind VARS to VALUES using letrec at CALL.  If CALL is already a letrec
;; call, just add to it, otherwise make a new one.

(define (put-in-letrec vars values call)
  (cond ((eq? 'letrec2 (primop-id (call-primop call)))
         (let ((binder (node-parent call)))
           (mark-changed call)
           (for-each (lambda (var)
                       (set-variable-binder! var binder))
                     vars)
           (set-lambda-variables! binder
                                  (append (lambda-variables binder) vars))
           (for-each (lambda (value)
                       (append-call-arg call value))
                     values)))
        (else
         (move-body
          call
          (lambda (call)
            (receive (letrec-call letrec-cont)
                (make-letrec vars values)
              (attach-body letrec-cont call)
              letrec-call))))))

(define (make-letrec vars vals)
  (let ((cont (make-lambda-node 'c 'cont '())))
    (let-nodes ((call (letrec1 1 l2))
                (l2 ((x #f) . vars) (letrec2 1 cont (* x) . vals)))
      (values call cont))))
