;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees, Mike Sperber
;;;
;;;  scheme48-1.9.2/scheme/prescheme/interface.scm
;;;

(define-module (language prescheme core)
  #:use-module (prescheme scheme48)
  #:use-module (prescheme prescheme)
  #:use-module (prescheme memory)
  #:use-module (prescheme ps-defenum)
  #:use-module (prescheme ps-record-types)
  #:re-export
  (;; prescheme-interface
   if begin lambda letrec quote set!
   define define-syntax let-syntax letrec-syntax
   and cond case do let let* or
   quasiquote
   syntax-rules
   ;; no delay

   goto
   external

   define-enumeration define-external-enumeration enum
   name->enumerand enumerand->name  ;; loadtime only

   not

   eq?
   + - * = <  ;; /
   <= > >=
   abs
   expt
   quotient remainder
   ;; floor numerator denominator
   ;; real-part imag-part
   ;; exp log sin cos tan asin acos atan sqrt
   ;; angle magnitude make-polar make-rectangular
   min max
   char=? char<?

   ;; Data manipulation
   make-vector vector-length
   vector-ref vector-set!

   make-string string-length
   string-ref string-set!

   deallocate
   null-pointer
   null-pointer?

   values call-with-values

   current-input-port current-output-port current-error-port
   open-input-file open-output-file
   close-output-port close-input-port

   read-char peek-char read-integer
   write-char newline write-string write-integer
   force-output

   errors
   error-string

   ascii->char char->ascii

   shift-left arithmetic-shift-right logical-shift-right
   bitwise-and bitwise-ior bitwise-xor bitwise-not
   unspecific
   error

   ;; ps-memory
   allocate-memory
   deallocate-memory

   unsigned-byte-ref unsigned-byte-set!
   word-ref word-set!
   flonum-ref flonum-set!

   address?
   null-address null-address?

   address+ address- address-difference
   address= address< address<= address> address>=
   address->integer integer->address

   copy-memory! memory-equal?

   char-pointer->string char-pointer->nul-terminated-string

   read-block write-block

   ;; memory-debug
   reinitialize-memory

   ;; ps-record-types
   define-record-type

   ;; ps-flonums
   fl+ fl- fl* fl/ fl= fl< fl> fl<= fl>=

   ;; ps-unsigned-integers
   un+ un- un* unquotient unremainder un= un< un> un<= un>=
   unsigned->integer integer->unsigned

   ;; ps-receive
   receive))
