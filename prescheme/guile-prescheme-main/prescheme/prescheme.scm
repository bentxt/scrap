;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber
;;;
;;;  scheme48-1.9.2/scheme/prescheme/prescheme.scm
;;;
;;; Stuff in Pre-Scheme that is not in Scheme.
;;;

(define-module (prescheme prescheme)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme platform)
  #:use-module (prescheme ps-defenum)
  #:use-module ((rnrs io simple)
                #:select (open-input-file
                          open-output-file
                          close-input-port
                          close-output-port
                          read-char
                          peek-char)
                #:prefix scheme:)
  #:export (shift-left arithmetic-shift-right logical-shift-right

            deallocate
            null-pointer
            null-pointer?

            errors
            error-string

            read-integer write-integer
            write-string

            goto
            external

            fl+ fl- fl* fl/ fl= fl< fl> fl<= fl>=

            un+ un- un* unquotient unremainder un= un< un> un<= un>=
            unsigned->integer integer->unsigned)
  #:replace (current-error-port
             open-input-file open-output-file
             close-output-port close-input-port

             read-char peek-char
             write-char newline
             force-output))

(define shift-left arithmetic-shift)

(define (arithmetic-shift-right i n)
  (arithmetic-shift i (- 0 n)))

;; Hack for the robots
(define small* *) ;; could do a range check

(define int-mask (- (arithmetic-shift 1 pre-scheme-integer-size) 1))

(define (logical-shift-right i n)
  (if (>= i 0)
      (arithmetic-shift i (- 0 n))
      (arithmetic-shift (bitwise-and i int-mask) (- 0 n))))

(define (deallocate x) #f)
(define the-null-pointer (list 'null-pointer))
(define (null-pointer? x) (eq? x the-null-pointer))
(define (null-pointer)
  the-null-pointer)

(define-external-enumeration errors
  (no-errors
   (parse-error    "EDOM")
   (file-not-found "ENOENT")
   (out-of-memory  "ENOMEM")
   (invalid-port   "EBADF")
   ))

(define (error-string status)
  "an error")
;; (symbol->string (enumerand->name status errors)))

(define (open-input-file name)
  (let ((port (scheme:open-input-file name)))
    (values port
            (if port
                (enum errors no-errors)
                (enum errors file-not-found)))))

(define (open-output-file name)
  (let ((port (scheme:open-output-file name)))
    (values port
            (if port
                (enum errors no-errors)
                (enum errors file-not-found)))))

(define (close-input-port port)
  (scheme:close-input-port port)
  (enum errors no-errors))

(define (close-output-port port)
  (scheme:close-output-port port)
  (enum errors no-errors))

(define (read-char port)
  (let ((ch (scheme:read-char port)))
    (if (eof-object? ch)
        (values (ascii->char 0) #t (enum errors no-errors))
        (values ch #f (enum errors no-errors)))))

(define (peek-char port)
  (let ((ch (scheme:peek-char port)))
    (if (eof-object? ch)
        (values (ascii->char 0) #t (enum errors no-errors))
        (values ch #f (enum errors no-errors)))))

(define (read-integer port)
  (eat-whitespace! port)
  (let ((neg? (let ((x (scheme:peek-char port)))
                (if (eof-object? x)
                    #f
                    (case x
                      ((#\+) (scheme:read-char port) #f)
                      ((#\-) (scheme:read-char port) #t)
                      (else #f))))))
    (let loop ((n 0) (any? #f))
      (let ((x (scheme:peek-char port)))
        (cond ((and (char? x)
                    (char-numeric? x))
               (scheme:read-char port)
               (loop (+ (* n 10)
                        (- (char->integer x)
                           (char->integer #\0)))
                     #t))
              (any?
               (values (if neg? (- n) n) #f (enum errors no-errors)))
              ((eof-object? x)
               (values 0 #t (enum errors no-errors)))
              (else
               (values 0 #f (enum errors parse-error))))))))

(define (eat-whitespace! port)
  (cond ((char-whitespace? (scheme:peek-char port))
         (scheme:read-char port)
         (eat-whitespace! port))))

(define (write-x string port)
  (display string port)
  (enum errors no-errors))

(define write-char write-x)
(define write-string write-x)
(define write-integer write-x)

(define (force-output port)
  (enum errors no-errors))

(define (newline port)
  (write-char #\newline port)
  (enum errors no-errors))

(define-syntax goto
  (syntax-rules ()
    ((_ func args ...)
     (func args ...))))

;; (external <string> <type> . <maybe scheme value>)

(define-syntax external
  (syntax-rules ()
    ((_ c-name ps-type)
     (error "not implemented:" '(_ c-name ps-type)))
    ((_ c-name ps-type scm-value)
     scm-value)))

(define current-error-port current-output-port)

;; ps-flonums
(define fl+ +) (define fl- -) (define fl* *) (define fl/ /)
(define fl= =)
(define fl< <) (define fl> >)
(define fl<= <=) (define fl>= >=)

;; ps-unsigned-integers
(define un+ +) (define un- -) (define un* *)
(define unquotient quotient)
(define unremainder remainder)
(define un= =)
(define un< <) (define un> >)
(define un<= <=) (define un>= >=)
(define (unsigned->integer x) x)
(define (integer->unsigned x) x)
