;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey
;;;
;;;   scheme48-1.9.2/ps-compiler/util/byte-vector.scm

(define-module (ps-compiler util byte-vector)
  #:use-module (prescheme scheme48)
  #:export (make-byte-vector byte-vector? byte-vector-length
            byte-vector-ref  byte-vector-word-ref  byte-vector-half-word-ref
            byte-vector-set! byte-vector-word-set! byte-vector-half-word-set!
            byte-vector-endianess set-byte-vector-endianess!))

(define (byte-vector-endianess)
  (if (eq? byte-vector-word-ref high-byte-vector-word-ref)
      'high
      'low))

(define (set-byte-vector-endianess! high-or-low)
  (case high-or-low
    ((high)
     (set! byte-vector-word-ref       high-byte-vector-word-ref)
     (set! byte-vector-half-word-ref  high-byte-vector-half-word-ref)
     (set! byte-vector-word-set!      high-byte-vector-word-set!)
     (set! byte-vector-half-word-set! high-byte-vector-half-word-set!))
    ((low)
     (set! byte-vector-word-ref       low-byte-vector-word-ref)
     (set! byte-vector-half-word-ref  low-byte-vector-half-word-ref)
     (set! byte-vector-word-set!      low-byte-vector-word-set!)
     (set! byte-vector-half-word-set! low-byte-vector-half-word-set!))
    (else
     (error "endianess specifier is neither HIGH nor LOW" high-or-low))))

(define (high-byte-vector-word-ref vector index)
  (+ (byte-vector-ref vector (+ index 3))
     (arithmetic-shift
      (+ (byte-vector-ref vector (+ index 2))
         (arithmetic-shift
          (+ (byte-vector-ref vector (+ index 1))
             (arithmetic-shift
              (byte-vector-ref vector index)
              8))
          8))
      8)))

(define (high-byte-vector-word-set! vector index value)
  (byte-vector-set! vector index       (arithmetic-shift value -24))
  (byte-vector-set! vector (+ index 1) (arithmetic-shift value -16))
  (byte-vector-set! vector (+ index 2) (arithmetic-shift value -8))
  (byte-vector-set! vector (+ index 3)                   value))

(define (high-byte-vector-half-word-ref vector index)
  (+ (byte-vector-ref vector (+ index 1))
     (arithmetic-shift
      (byte-vector-ref vector index)
      8)))

(define (high-byte-vector-half-word-set! vector index value)
  (byte-vector-set! vector index       (arithmetic-shift value -8))
  (byte-vector-set! vector (+ index 1)                   value))

(define (low-byte-vector-word-ref vector index)
  (+ (byte-vector-ref vector index)
     (arithmetic-shift
      (+ (byte-vector-ref vector (+ index 1))
         (arithmetic-shift
          (+ (byte-vector-ref vector (+ index 2))
             (arithmetic-shift
              (byte-vector-ref vector (+ index 3))
              8))
          8))
      8)))

(define (low-byte-vector-word-set! vector index value)
  (byte-vector-set! vector index                         value)
  (byte-vector-set! vector (+ index 1) (arithmetic-shift value -8))
  (byte-vector-set! vector (+ index 2) (arithmetic-shift value -16))
  (byte-vector-set! vector (+ index 3) (arithmetic-shift value -24)))

(define (low-byte-vector-half-word-ref vector index)
  (+ (byte-vector-ref vector index)
     (arithmetic-shift
      (byte-vector-ref vector (+ index 1))
      8)))

(define (low-byte-vector-half-word-set! vector index value)
  (byte-vector-set! vector index                         value)
  (byte-vector-set! vector (+ index 1) (arithmetic-shift value -8)))

;; Start high-endian
(define byte-vector-word-ref       high-byte-vector-word-ref)
(define byte-vector-half-word-ref  high-byte-vector-half-word-ref)
(define byte-vector-word-set!      high-byte-vector-word-set!)
(define byte-vector-half-word-set! high-byte-vector-half-word-set!)
