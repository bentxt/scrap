;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Mike Sperber
;;;
;;;   scheme48-1.9.2/ps-compiler/util/syntax.scm
;;;
;;; Syntax used by the compiler
;;;
;;; Subrecords
;;;
;;; SUPER is the name of the existing record
;;; SUB is the name of the subrecord
;;; SLOT is the name of the slot to use in the existing sturcture
;;; STUFF is the usual stuff from DEFINE-RECORD-TYPE

(define-module (ps-compiler util syntax)
  #:use-module (srfi srfi-1)
  #:use-module (prescheme s48-defrecord)
  #:use-module (prescheme syntax-utils)
  #:export (define-subrecord
            define-subrecord-type
            define-local-syntax))

(define-syntax define-subrecord
  (lambda (x)
    (syntax-case x ()
      ((_ super sub slot (arg-defs ...) (other-defs ...))
       (let* ((field-names (map (lambda (def)
                                  (syntax-case def ()
                                    ((fname _ ...) #'fname)
                                    (fname #'fname)))
                                #'(arg-defs ... other-defs ...)))
              (field-setter? (append (map (lambda (def)
                                            (syntax-case def ()
                                              ((fname) #t)
                                              (_ #f)))
                                          #'(arg-defs ...))
                                     (make-list
                                      (length #'(other-defs ...)) #t))))
         #`(begin
             (define-record-type sub
               (arg-defs ...)
               (other-defs ...))
             #,@(map (lambda (fname)
                       (let ((super-get (syntax-conc #'super '- fname))
                             (sub-get (syntax-conc #'sub '- fname)))
                         #`(define (#,super-get v)
                             (#,sub-get (slot v)))))
                     field-names)
             #,@(filter-map (lambda (fname setter?)
                              (and setter?
                                   (let ((super-set (syntax-conc 'set- #'super '- fname '!))
                                         (sub-set (syntax-conc 'set- #'sub '- fname '!)))
                                     #`(define (#,super-set v n)
                                         (#,sub-set (slot v) n)))))
                            field-names field-setter?)
             ))))))

;; Subrecords, version for JAR/SRFI-9 records
;; This should eventually replace the above.
;;
;; (define-subrecord-type id type-name super-slot
;;   (maker ...)
;;   predicate?
;;   (slot accessor [modifier])
;;   ...)
;;
;; SUPER-SLOT is the name of the slot to use in the existing record.

#|
(define-syntax define-subrecord-type
  (lambda (form rename compare)
    (let ((id (cadr form))
          (type (caddr form))
          (slot (cadddr form))
          (rest (cddddr form))
          (%define-record-type (rename 'define-record-type))
          (%define (rename 'define))
          (%x (rename 'v))
          (%v (rename 'x)))
      (let ((maker (car rest))
            (pred (cadr rest))
            (slots (cddr rest))
            (gensym (lambda (s i)
                      (rename (string->symbol
                               (string-append (symbol->string s)
                                              "%"
                                              (number->string i)))))))
        `(begin
           (,%define-record-type ,id ,type
               ,maker
               ,pred
               ,@(do ((slots slots (cdr slots))
                      (i 0 (+ i 1))
                      (new '() `((,(caar slots)
                                  ,(gensym 'subrecord-ref i)
                                  ,@(if (null? (cddar slots))
                                        '()
                                        `(,(gensym 'subrecord-set i))))
                                 . ,new)))
                     ((null? slots)
                      (reverse new))))
               ,@(do ((slots slots (cdr slots))
                      (i 0 (+ i 1))
                      (new '() `(,@(if (null? (cddar slots))
                                       '()
                                       `((,%define (,(caddar slots) ,%x ,%v)
                                           (,(gensym 'subrecord-set i)
                                            (,slot ,%x)
                                            ,%v))))
                                 (,%define (,(cadar slots) ,%x)
                                     (,(gensym 'subrecord-ref i)
                                      (,slot ,%x)))
                                 . ,new)))
                     ((null? slots)
                      (reverse new))))))))
|#

;;(define-syntax define-simple-record-type
;;  (lambda (form rename compare)
;;    (let ((name (cadr form))
;;          (slots (cddr form)))
;;      `(begin (define-record-type ,name ,slots ())
;;              (define ,(concatenate-symbol 'make- name)
;;                ,(concatenate-symbol name '- 'maker))))))

;; Nothing actually local about it...

#|
(define-syntax define-local-syntax
  (lambda (form rename compare)
    (let ((pattern (cadr form))
          (body (cddr form)))
      `(,(rename 'define-syntax) ,(car pattern)
         (,(rename 'lambda) (form rename compare)
           (,(rename 'destructure) ((,(cdr pattern)
                                     (,(rename 'cdr) form)))
             . ,body))))))
|#
