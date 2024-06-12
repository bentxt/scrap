;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/prescheme/spec.scm
;;;
;;; Protocol specifications are lists of representations.

(define-module (ps-compiler prescheme spec)
  #:use-module ((ps-compiler param) #:select (set-compiler-parameter!))
  #:use-module (ps-compiler node arch)
  #:use-module (ps-compiler node let-nodes)
  #:use-module (ps-compiler node node)
  #:use-module (ps-compiler node node-util)
  #:use-module (ps-compiler node primop)
  #:use-module (ps-compiler node variable)
  #:use-module (ps-compiler prescheme type)
  #:use-module (ps-compiler prescheme primop primop)
  #:use-module (ps-compiler util util)
  #:export (normal-protocol
            goto-protocol
            goto-protocol?))

(set-compiler-parameter! 'lambda-node-type
                         (lambda (node)
                           (let ((vars (lambda-variables node)))
                             (case (lambda-type node)
                               ((cont jump)
                                (make-arrow-type (map variable-type vars)
                                                 type/unknown)) ;; what to do?
                               ((proc known-proc)
                                (make-arrow-type (map variable-type (cdr vars))
                                                 (variable-type (car vars))))
                               (else
                                (error "unknown type of lambda node ~S" node))))))

(set-compiler-parameter! 'true-value #t)
(set-compiler-parameter! 'false-value #f)

;; Tail-calls with goto-protocols cause the lambda node to be annotated
;; as tail-called.
;; Calls with a tuple argument need their argument spread out into separate
;; variables.

(define (determine-lambda-protocol lambda-node call-refs)
  (set-lambda-protocol! lambda-node #f)
  (for-each (lambda (r)
              (let ((call (node-parent r)))
                (cond ((goto-protocol? (literal-value (call-arg call 2)))
                       (if (not (calls-this-primop? call 'unknown-tail-call))
                           (bug "GOTO marker in non-tail-all ~S" call))
                       (set-lambda-protocol! lambda-node 'tail-called)))
                (unknown-call->known-call call)))
            call-refs)
  (set-calls-known?! lambda-node))

(set-compiler-parameter! 'determine-lambda-protocol determine-lambda-protocol)

(define (unknown-call->known-call the-call)
  (remove-call-arg the-call 2)  ;; remove the protocol
  (set-call-primop! the-call
                    (case (primop-id (call-primop the-call))
                      ((unknown-call)
                       (get-primop (enum primop-enum call)))
                      ((unknown-tail-call)
                       (get-primop (enum primop-enum tail-call)))
                      (else
                       (bug "odd primop in call ~S" the-call)))))

;; CONT is the continuation passed to PROCS.

(define (determine-continuation-protocol cont procs)
  (for-each (lambda (proc)
              (let ((cont-var (car (lambda-variables proc))))
                (walk-refs-safely
                 (lambda (ref)
                   (let ((call (node-parent ref)))
                     (unknown-return->known-return call cont-var cont)))
                 cont-var)))
            procs))

(set-compiler-parameter! 'determine-continuation-protocol
                         determine-continuation-protocol)

;; If the return is actually a tail-recursive call we change it to
;; a non-tail-recursive one (since we have identified the continuation)
;; and insert the appropriate continuation.

(define (unknown-return->known-return the-call cont-var cont)
  (case (primop-id (call-primop the-call))
    ((unknown-return)
     (set-call-primop! the-call (get-primop (enum primop-enum return))))
    ((unknown-tail-call tail-call)
     (let* ((vars (map copy-variable (lambda-variables cont)))
            (args (map make-reference-node vars)))
       (let-nodes ((cont vars (return 0 (* cont-var) . args)))
         (replace (call-arg the-call 0) cont)
         (set-call-primop! the-call
                           (if (calls-this-primop? the-call 'tail-call)
                               (get-primop (enum primop-enum call))
                               (get-primop (enum primop-enum unknown-call))))
         (set-call-exits! the-call 1)
         (if (and (calls-this-primop? the-call 'unknown-call)
                  (goto-protocol? (literal-value (call-arg the-call 2))))
             (set-literal-value! (call-arg the-call 2) #f)))))
    (else
     (bug "odd return primop ~S" (call-primop the-call)))))

(define normal-protocol #f)
(define goto-protocol 'goto)

(define (goto-protocol? x)
  (eq? x goto-protocol))

(set-compiler-parameter! 'lookup-primop get-prescheme-primop)

(set-compiler-parameter! 'type/unknown type/unknown)

(set-compiler-parameter! 'type-eq? type-eq?)

