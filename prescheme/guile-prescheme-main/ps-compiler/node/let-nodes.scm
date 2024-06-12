;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey,
;;;
;;;   scheme48-1.9.2/ps-compiler/node/let-nodes.scm
;;;
;;; This is a backquote-like macro for building nodes.
;;;
;;; One goal is to produce code that is as efficient as possible.
;;; We aren't quite there yet.
;;;
;;; (LET-NODES (<spec1> ... <specN>) . <body>)
;;; (NEW-CALL <primop-id> <exits> . <arg-list>)
;;; These all create cont lambdas:
;;; (NEW-LAMBDA (<var1> ... <varN>) <call-exp>)
;;; (NEW-LAMBDA (<var1> ... <varN> . <last-vars>) <call-exp>)
;;; (NEW-LAMBDA <vars> <call-exp>)
;;; (NEW-LAMBDA (<var1> ... <varN>))
;;; (NEW-LAMBDA (<var1> ... <varN> . <last-vars>))
;;; (NEW-LAMBDA <vars>)
;;;
;;; <spec> ::= (<ident> <real-call>) |                            ; call node
;;;            (<ident> (<var1> ... <varN>) <call>) |             ; cont lambda node
;;;            (<ident> (<var1> ... <varN> . <last-vars>) <call>) ; cont lambda node
;;;            (<ident> <vars> <call>) |                          ; cont lambda node
;;;
;;; <var>  ::= #f |             Ignored variable position
;;;            <ident> |        Evaluate <ident> and copy it, rebinding <ident>
;;;            '<ident> |       Evaluate <ident> to get the variable
;;;            (<ident> <rep>)  (MAKE-VARIABLE <ident> <rep>)
;;;
;;; <last-vars> ::= <ident>
;;;
;;; <call> ::= <ident> | <real-call>
;;;
;;; <real-call> ::= (<primop-id> <exits> . <arg-list>)
;;;
;;; <arg-list> ::= (<arg1> ... <argN>) | (<arg1> ... <argN> . <last-args>)
;;;
;;; <last-args> ::= <ident>
;;;
;;; <arg>  ::= 'foo        literal node containing the value of foo, no rep
;;;            '(foo rep)     "     "       "       "    "   "   " , using rep
;;;            (* foo)     reference to foo (which evaluates to a variable)
;;;            (! foo)     foo evaluates to a node
;;;            foo         short for (! foo) when foo is an atom
;;;            #f          put nothing here
;;;            (<primop-id> . <arg-list>)   a nested (simple) call
;;;--------------------------------------
;;;
;;; Example:
;;;
;;; (let-nodes ((call (let 1 l1 . vals))
;;;             (l1 vars lr1))
;;;   call)
;;; ====>
;;; (let ((call (make-call-node (get-primop (enum primop let) (+ 1 (length vals)) 1)))
;;;       (l1 (make-lambda-node 'c 'cont (append (list) vars))))
;;;   (attach-call-args call (append (list l1) vals))
;;;   (attach-body l1 lr1)
;;;   call)

(define-module (ps-compiler node let-nodes)
  #:use-module (srfi srfi-8)
  #:use-module (prescheme scheme48)
  #:use-module (ps-compiler node arch)
  #:use-module (ps-compiler node node)
  #:use-module (ps-compiler node node-util)
  #:use-module (ps-compiler node primop)
  #:use-module (ps-compiler node variable)
  #:use-module (ps-compiler param)
  #:use-module (ps-compiler util util)
  #:export (let-nodes new-lambda new-call))

(define-syntax let-nodes
  (lambda (x)
    (syntax-case x ()
      ((_ (specs ...) body ...)
       (receive (vars nodes code)
           (parse-node-specs #'(specs ...))
         #`(let #,vars
             (let #,nodes
               #,@code
               body ...)))))))

;; (NEW-LAMBDA (<var1> ... <varN>) <call-exp>)
;; (NEW-LAMBDA (<var1> ... <varN> . <last-vars>) <call-exp>)
;; (NEW-LAMBDA <vars> <call-exp>)
;; (NEW-LAMBDA (<var1> ... <varN>))
;; (NEW-LAMBDA (<var1> ... <varN> . <last-vars>))
;; (NEW-LAMBDA <vars>)

(define-syntax new-lambda
  (lambda (x)
    (syntax-case x ()
      ((_ vars)
       (receive (vars node)
           (construct-vars #'vars)
         #`(let #,vars
             #,node)))
      ((_ vars maybe-call)
       (receive (vars node)
           (construct-vars #'vars)
         #`(let #,vars
             (let ((the-lambda #,node)
                   (the-call maybe-call))
               (attach-body the-lambda the-call)
               the-lambda)))))))

(define-syntax new-call
  (lambda (x)
    (syntax-case x (the-call)
      ((_ specs ...)
       (let ((call-name #'the-call))
         (receive (node code)
             (construct-call call-name #'(specs ...))
         #`(let ((#,call-name #,node))
                 #,@code
                 #,call-name)))))))

;; Parse the specs, returning a list of variable specs, a list of node specs,
;; and a list of construction forms.  An input spec is either a call or a
;; lambda, each is parsed by an appropriate procedure.

(define (parse-node-specs specs)
  (let loop ((specs (reverse specs)) (vars '()) (nodes '()) (codes '()))
    (if (null? specs)
        (values vars nodes codes)
        (syntax-case specs ()
          (((name spec) . rest)
           (receive (node code)
               (construct-call #'name #'spec)
             (loop #'rest vars
                   (cons #`(name #,node) nodes)
                   (append code codes))))
          (((name vs call) . rest)
           (receive (vs node new-spec call)
               (construct-lambda #'vs #'call)
             (loop (if new-spec (cons new-spec #'rest) #'rest)
                   (append vs vars)
                   (cons #`(name #,node) nodes)
                   (if call
                       (cons #`(attach-body name #,call) codes)
                       codes))))))))

;; The names of the call-arg relation procedures, indexed by the number of
;; arguments handled.

(define call-attach-names
  '#(#f
     #f
     attach-two-call-args
     attach-three-call-args
     attach-four-call-args
     attach-five-call-args))

;; Return the node spec and construction forms for a call.  This dispatches
;; on whether the argument list is proper or not.
;;
;; <real-call> ::= (<arg0> <exits> <arg1> ... <argN>) |
;;                 (<arg0> <exits> <arg1> ... <argN> . <last-args>))

(define (construct-call name specs)
  (syntax-case specs ()
    ((proc arg . args)
     (really-construct-call name #'proc #'arg '() #'args))))

(define (construct-nested-call specs)
  (syntax-case specs (call)
    ((primop-id args ...)
     (let ((name #'call))
       (receive (node code)
           (really-construct-call name #'primop-id 0 '() #(args ...))
         #`(let ((#,name #,node))
             #,@code
             #,name))))))

(define (really-construct-call name primop-id exits extra args)
  (receive (arg-count arg-code)
      (parse-call-args name extra args)
    (let ((primop-code (get-primop-code primop-id)))
      (values #`(make-call-node #,primop-code #,arg-count #,exits)
              arg-code))))

(define (get-primop-code id)
  (cond ((name->enumerand (syntax->datum id) primop-enum)
         => (lambda (n)
              #`(get-primop #,n)))
        (else
         #`(lookup-primop '#,id))))

;; NAME     = the call node which gets the arguments
;; EXTRA    = initial, already expanded arguments
;; ARGS     = unexpanded arguments
;; LAST-ARG = an atom whose value is added to the end of the arguments
;; Returns ARG-COUNT-CODE and ARG-CODE

(define (parse-call-args name extra args)
  (receive (args last-arg)
      (decouple-improper-list args)
    (let* ((args (append extra (map construct-node args)))
           (count (length args)))
      (if (not (null? last-arg))
          (values #`(+ #,count (length #,last-arg))
                  #`((attach-call-args
                      #,name
                      #,(if (null? args)
                            last-arg
                            #`(append (list #,@args) #,last-arg)))))
          (values count
                  (cond ((= count 0)
                         '())
                        ((and (= count 1) (car args))
                         #`((attach #,name 0 #,(car args))))
                        ((and (< count 6)
                              (every? identity args))
                         #`((#,(datum->syntax name (vector-ref call-attach-names count))
                             #,name
                             #,@args)))
                        (else
                         #`((attach-call-args #,name (list #,@args))))))))))

;; Return proper part of the list and its last-cdr separately.

(define (decouple-improper-list ls)
  (let loop ((ls ls) (res '()))
    (syntax-case ls ()
      ((head . tail)
       (loop #'tail (cons #'head res)))
      (last-arg
       (values (reverse! res) #'last-arg)))))

;; Dispatch on the type of the SPEC and return the appropriate code.
;;
;; <arg>  ::= 'foo         literal node containing the value of foo, no rep
;;            '(foo rep)   literal node containing the value of foo
;;            (* foo)      reference to foo (which evaluates to a variable)
;;            (! foo)      foo evaluates to a node
;;            name         short for (! name) when foo is an atom
;;            #f          put nothing here
;;            (<primop-id> . <arg-list>)   a nested (simple) call

(define (construct-node spec)
  (syntax-case spec ()
    ((key data)
     (case (syntax->datum #'key)
       ((*)     #'(make-reference-node data))
       ((quote) (if (pair? #'data)
                    #'(make-literal-node data)
                    #'(make-literal-node data 'type/unknown)))
       ((!)     #'data)
       (else
        (construct-nested-call spec))))
    (spec #'spec)))

;; Parse a lambda spec.  This returns a list of variable specs, code to
;; construct the lambda node, a spec for the body if necessary, and
;; the code needed to put it all together.

(define (construct-lambda vars call)
  (receive (vars node)
      (construct-vars vars)
    (syntax-case call ()
      (()
       (values vars node #f #f))
      ((head . tail)
       (let ((sym (datum->syntax call (generate-symbol 'c))))
         (values vars node #`(#,sym (head . tail)) sym)))
      (call
       (values vars node #f #'call)))))

;; Returns the code needed to construct the variables and the code to make
;; the lambda node that binds the variables.
;;
;; <var>  ::= #f |             Ignored variable position
;;            <ident> |        Evaluate <ident> and copy it, rebinding <ident>
;;            '<ident> |       Evaluate <ident> to get the variable
;;            (<ident> <rep>)  (MAKE-VARIABLE <ident> <rep>)

(define (construct-vars vars)
  (let loop ((vs vars) (vlist '()) (code '()))
    (syntax-case vs (quote)
      ((() . rest)
       (loop #'rest
             (cons #'#f vlist)
             code))
      (((quote ident) . rest)
       (loop #'rest
             (cons #'ident vlist)
             code))
      (((ident rep) . rest)
       (loop #'rest
             (cons #'ident vlist)
             (cons #'(ident (make-variable 'ident rep)) code)))
      ((ident . rest)
       (loop #'rest
             (cons #'ident vlist)
             (cons #'(ident (copy-variable ident)) code)))
      (()
       (values code
               #`(make-lambda-node 'c 'cont (list #,@(reverse! vlist)))))
      (vs
       (values code
               #`(make-lambda-node 'c 'cont (append (list #,@(reverse! vlist)) vs)))))))

;;------------------------------------------------------------------------------
;; GENSYM utility

(define *generate-symbol-index* 0)

(define (generate-symbol sym)
  (let ((i *generate-symbol-index*))
    (set! *generate-symbol-index* (+ i 1))
    (concatenate-symbol sym "." i)))
