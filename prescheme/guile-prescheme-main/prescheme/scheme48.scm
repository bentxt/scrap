;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber, Robert Ransom
;;;
;;;   scheme48-1.9.2/scheme/big/big-util.scm
;;;   scheme48-1.9.2/scheme/big/more-port.scm
;;;   scheme48-1.9.2/scheme/rts/current-port.scm
;;;   scheme48-1.9.2/scheme/rts/exception.scm
;;;   scheme48-1.9.2/scheme/rts/util.scm

(define-module (prescheme scheme48)
  #:use-module (ice-9 format)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 q)
  #:use-module (srfi srfi-8)
  #:use-module (srfi srfi-60)
  #:use-module (srfi srfi-111)
  #:use-module (rnrs bytevectors)
  #:use-module (rnrs io ports)
  #:use-module (prescheme s48-defenum)
  #:export (arithmetic-shift
            ascii->char
            char->ascii
            ascii-limit
            unspecific
            unspecific?
            make-code-vector
            code-vector?
            code-vector-ref
            code-vector-set!
            code-vector-length
            make-table
            make-integer-table
            make-symbol-table
            table-ref
            table-set!
            table-walk
            make-queue
            enqueue!
            dequeue!
            queue-empty?
            immutable?
            make-immutable!
            make-table-immutable!
            make-cell
            cell-ref
            cell-set!
            fluid-cell-ref
            fluid-cell-set!
            byte-ready?
            peek-byte
            read-byte
            write-byte
            current-column
            current-line
            make-tracking-input-port
            make-tracking-output-port
            call-with-string-output-port
            current-noise-port
            write-one-line
            assertion-violation
            warning
            concatenate-symbol
            breakpoint
            atom?
            neq?
            n=
            memq?
            first
            any
            no-op
            null-list?
            any?
            every?
            filter-map
            partition-list
            reduce
            fold
            fold->3
            every
            last)
  #:re-export (define-enumeration
               enum
               name->enumerand
               enumerand->name
               bitwise-and
               bitwise-ior
               bitwise-xor
               bitwise-not
               receive))

(define arithmetic-shift ash)

(define ascii->char integer->char)
(define char->ascii char->integer)

(define ascii-limit 128)

(define unspecific (if #f #f))
(define (unspecific? x) (eq? x unspecific))

(define make-code-vector make-bytevector)
(define code-vector? bytevector?)
(define code-vector-ref bytevector-u8-ref)
(define code-vector-set! bytevector-u8-set!)
(define code-vector-length bytevector-length)

(define make-table make-hash-table)
(define make-integer-table make-hash-table)
(define make-symbol-table make-hash-table)
(define table-ref hash-ref)
(define table-set! hash-set!)
(define table-walk hash-for-each)

(define make-queue make-q)
(define enqueue! enq!)
(define dequeue! deq!)
(define queue-empty? q-empty?)

(define (immutable? x) #f)
(define (make-immutable! x) x)
(define (make-table-immutable! x) x)

(define make-cell box)
(define cell-ref unbox)
(define cell-set! set-box!)

(define (fluid-cell-ref x)
  (cell-ref (fluid-ref x)))
(define (fluid-cell-set! x v)
  (cell-set! (fluid-ref x) v))

(define byte-ready? char-ready?)
(define peek-byte lookahead-u8)
(define read-byte get-u8)
(define write-byte put-u8)

(define current-column port-column)
(define current-line port-line)
(define make-tracking-input-port identity)
(define make-tracking-output-port identity)
(define call-with-string-output-port call-with-output-string)

(define current-noise-port current-error-port)

(define (write-one-line port count proc)
  ;; FIXME port write-one-line from scheme/big/more-port.scm
  (proc port))

(define (assertion-violation who message . irritants)
  (apply error message irritants))

(define (warning who message . irritants)
  ;; FIXME review exception handling
  (apply error message irritants))

(define (concatenate-symbol . stuff)
  (string->symbol
   (apply string-append
          (map (lambda (x)
                 (cond ((string? x) x)
                       ((symbol? x) (symbol->string x))
                       ((number? x) (number->string x))
                       (else
                        (assertion-violation 'concatenate-symbol "cannot coerce to a string"
                                             x))))
               stuff))))

(define (breakpoint format-string . args)
  (error (apply format (cons #f (cons format-string args)))))

(define (atom? x)
  (not (pair? x)))

(define (neq? a b)
  (not (eq? a b)))

(define (n= x y)
  (not (= x y)))

(define (memq? x l)
  (let loop ((l l))
    (cond ((null? l)       #f)
          ((eq? x (car l)) #t)
          (else            (loop (cdr l))))))

(define (first pred list)
  (let loop ((list list))
    (cond ((null? list)
           #f)
          ((pred (car list))
           (car list))
          (else
           (loop (cdr list))))))

(define any first)  ;; ANY need not search in order, but it does anyway

(define (no-op x) x)

(define (null-list? x)
  (cond ((null? x) #t)
        ((pair? x) #f)
        (else
         (assertion-violation 'null-list? "non-list" x))))

(define (any? proc list)
  (let loop ((list list))
    (cond ((null? list)
           #f)
          ((proc (car list))
           #t)
          (else
           (loop (cdr list))))))

(define (every? pred list)
  (let loop ((list list))
    (cond ((null? list)
           #t)
          ((pred (car list))
           (loop (cdr list)))
          (else
           #f))))

(define (filter-map f l)
  (let loop ((l l) (r '()))
    (cond ((null? l)
           (reverse r))
          ((f (car l))
           => (lambda (x)
                (loop (cdr l) (cons x r))))
          (else
           (loop (cdr l) r)))))

(define (partition-list pred l)
  (let loop ((l l) (yes '()) (no '()))
    (cond ((null? l)
           (values (reverse yes) (reverse no)))
          ((pred (car l))
           (loop (cdr l) (cons (car l) yes) no))
          (else
           (loop (cdr l) yes (cons (car l) no))))))

(define (reduce cons nil list)
  (if (null? list)
      nil
      (cons (car list) (reduce cons nil (cdr list)))))

(define (fold folder list accumulator)
  (do ((list list (cdr list))
       (accum accumulator (folder (car list) accum)))
      ((null? list)
       accum)))

(define (fold->3 folder list acc0 acc1 acc2)
  (let loop ((list list) (acc0 acc0) (acc1 acc1) (acc2 acc2))
    (if (null? list)
        (values acc0 acc1 acc2)
        (call-with-values
            (lambda ()
              (folder (car list) acc0 acc1 acc2))
          (lambda (acc0 acc1 acc2)
            (loop (cdr list) acc0 acc1 acc2))))))

(define (every pred l)
  (if (null? l)
      #t
      (and (pred (car l)) (every pred (cdr l)))))

(define (last x)
  (if (null? (cdr x))
      (car x)
      (last (cdr x))))
